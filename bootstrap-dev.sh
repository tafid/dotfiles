#!/usr/bin/env bash
set -Eeuo pipefail

PHP_VERSIONS=("8.3" "8.4" "8.5")
GLOBAL_PHP="8.4"
GLOBAL_NODE="24"

log() {
  printf '\n\033[1;32m==>\033[0m %s\n' "$*"
}

warn() {
  printf '\n\033[1;33m[warn]\033[0m %s\n' "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

append_if_missing() {
  local line="$1"
  local file="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}

if [[ "${EUID}" -eq 0 ]]; then
  echo "Запускай этот скрипт не от root."
  exit 1
fi

if ! need_cmd apt-get; then
  echo "Этот скрипт рассчитан на Debian/Ubuntu с APT."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

log "Обновляю APT и ставлю базовые инструменты"

sudo apt-get update
sudo apt-get install -y \
  ca-certificates \
  curl \
  git \
  gnupg \
  btop \
  jq \
  build-essential \
  ripgrep \
  fd-find \
  fzf \
  neovim \
  software-properties-common \
  tmux \
  tree \
  unzip \
  wget \
  zip \
  zsh \
  autoconf automake bison re2c pkg-config \
  libxml2-dev libsqlite3-dev libssl-dev libcurl4-openssl-dev \
  libonig-dev libreadline-dev libzip-dev libjpeg-dev libpng-dev \
  libwebp-dev libxpm-dev libfreetype-dev libgd-dev libicu-dev \
  libxslt1-dev libbz2-dev liblzma-dev libffi-dev libsodium-dev \
  libedit-dev zlib1g-dev libtidy-dev libgmp-dev unixodbc-dev libpq-dev

log "Ставлю Docker из официального репозитория"

sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
sudo install -m 0755 -d /etc/apt/keyrings

if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi

sudo chmod a+r /etc/apt/keyrings/docker.gpg

CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
ARCH="$(dpkg --print-architecture)"

echo \
  "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update
sudo apt-get install -y \
  containerd.io \
  docker-buildx-plugin \
  docker-ce \
  docker-ce-cli \
  docker-compose-plugin

if getent group docker >/dev/null 2>&1; then
  sudo usermod -aG docker "$USER"
else
  warn "Группа docker не найдена. Проверь установку Docker."
fi

log "Ставлю mise"

if [[ ! -x "$HOME/.local/bin/mise" ]] && ! need_cmd mise; then
  curl -fsSL https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

if ! need_cmd mise; then
  echo "Не удалось найти mise после установки."
  exit 1
fi

append_if 'eval "$($HOME/.local/bin/mise activate zsh)"' "$HOME/.zshrc"

eval "$(mise activate bash)"

log "Ставлю Rust через rustup"

if [[ ! -x "$HOME/.cargo/bin/rustup" ]] && ! need_cmd rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# shellcheck disable=SC1091
source "$HOME/.cargo/env"
append_if_missing 'source "$HOME/.cargo/env"' "$HOME/.zshrc"

rustup toolchain install stable
rustup default stable

#log "Ставлю Node.js через mise"
#
#mise install "node@${GLOBAL_NODE}"
#mise use --global "node@${GLOBAL_NODE}"

log "Ставлю PHP через mise"

for ver in "${PHP_VERSIONS[@]}"; do
  mise install "php@${ver}"
done

mise use --global "php@${GLOBAL_PHP}"

log "Финальная проверка"

echo "mise:           $(mise --version)"
echo "docker:         $(docker --version)"
echo "docker compose: $(docker compose version)"
echo "rustup:         $(rustup --version | head -n1)"
echo "cargo:          $(cargo --version)"
echo "rustc:          $(rustc --version)"
echo "node:           $(node --version)"
echo "npm:            $(npm --version)"
echo "php:            $(php -v | head -n1)"

cat <<'EOF'

Готово.

Что важно после установки:
1. Перезапусти shell:
   exec zsh

2. Чтобы Docker заработал без sudo, примени новую группу:
   newgrp docker

3. Для проекта можно переключать PHP так:
   mise use php@8.3
   mise use php@8.4
   mise use php@8.5

4. Глобальная версия PHP уже выставлена:
   php 8.4

5. Перенос конфигов и ключей:
   rsync -avh --progress ~/.config ~/.zshrc ~/.gitconfig ~/.ssh NEW_HOST:~/

6. После переноса SSH-ключей на новой машине:
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/id_ed25519 2>/dev/null || true
   chmod 644 ~/.ssh/id_ed25519.pub 2>/dev/null || true

EOF
