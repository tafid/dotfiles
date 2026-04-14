# If you come from bash you might have to change your $PATH.
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/opt/nvim/"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="candy"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z zsh-autosuggestions history zsh-syntax-highlighting fzf vi-mode) #  vi-mode

source $ZSH/oh-my-zsh.sh

export FZF_BASE=/usr/bin/fzf
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border top'

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"alias l="ls -lAF ${ls_options}"

alias l="ls -lAF ${ls_options}"
alias lh="ls -lF ${ls_options}"
alias la="ls -laF ${ls_options}"
alias ll="ls -lAFh ${ls_options}"
alias d='docker'
alias g='git'
alias lzg='lazygit'
alias lzd='lazydocker'
alias vim='nvim'
alias v='nvim'
alias bat='batcat'
alias dc='docker compose'
alias docker-compose='docker compose'
alias grep='grep --color=auto'
alias cu='eval $(ssh-agent); dc run -v $SSH_AUTH_SOCK:/ssh_agent -e SSH_AUTH_SOCK=/ssh_agent php-fpm sh -c "apt update; apt install -y git; bash"'
alias ca='eval $(ssh-agent); dc run -v $SSH_AUTH_SOCK:/ssh_agent -e SSH_AUTH_SOCK=/ssh_agent php-fpm sh -c "apk update; composer self-update; bash"'
alias nginx-proxy="docker network create nginx-proxy-network-127.0.0.2; docker run -d -p 80:80 --rm --network nginx-proxy-network-127.0.0.2 -v /home/tofid/.nginx_proxy.conf:/etc/nginx/conf.d/nginx_proxy.conf:ro -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy"
alias c='composer'
alias cc='eval $(ssh-agent); \
  docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --env SSH_AUTH_SOCK=/ssh-auth.sock \
  --user $(id -u):$(id -g) \
  composer/composer'
alias ls-tmux="tmux list-panes -aF '#{session_name}:#{window_index}:#{pane_index}	#{pane_tty}	#{pane_pid}	#{pane_current_command}'"
alias get-resource='psql -h localhost -p 50005 -U sol rcp -c "select * from resource where time >= to_month()" --csv -t -q -X > ~/trash/res.csv'
alias copy='xclip -sel clip'
alias wezterm='flatpak run org.wezfurlong.wezterm'

# alias set-resource='psql -h localhost -p 5432 -U sol rcp -c "\COPY resource FROM /home/tofid/trash/res.csv with delimiter \',\' CSV;"'

# Access device web browser settings using WebHID
# @see chrome://device-log
# @see https://www.reddit.com/r/archlinux/comments/1cas56j/access_mouse_web_browser_settings_using_webhid/
alias allow-hid="sudo chmod o+rw /dev/hidraw*"

export PATH="$HOME/bin:$PATH"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ffdd00,bg=#005f73,bold,underline"
ZSH_DEISABLE_COMPFIX=true

PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%H:%M:%S]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info)\
%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

eval "$(zoxide init zsh)"

# Created by `pipx` on 2025-08-03 14:44:16
export PATH="$PATH:/home/tofid/.local/bin"

# vi-mode settings
KEYTIMEOUT=1
VI_MODE_SET_CURSOR=true
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line
bindkey -M vicmd 'V' edit-command-line # this remaps `vv` to `V` (but overrides `visual-mode`)

# Define NVM directory path
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

eval "$($HOME/.local/bin/mise activate zsh)"
source "$HOME/.cargo/env"
