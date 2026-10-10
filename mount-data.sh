#!/usr/bin/env bash
# Подключает второй диск (Kingston, ext4, label "data") как /data — так же, как на Ubuntu.
# Диск ищется по UUID, а не по /dev/nvme*, потому что порядок nvme после переустановки может поменяться.
# Ничего не форматирует. Запускать до restore.sh; скрипт идемпотентен.
set -Eeuo pipefail

UUID=af98c53f-e79f-46f6-a458-f2f7ab5c4109
MNT=/data

dev=$(blkid -U "$UUID" || true)
if [[ -z $dev ]]; then
  echo "Диск с UUID=$UUID не найден. Что видит система:"; lsblk -f; exit 1
fi
[[ $(blkid -s TYPE -o value "$dev") == ext4 ]] || { echo "$dev не ext4 — стоп"; exit 1; }

sudo mkdir -p "$MNT"
grep -q "UUID=$UUID" /etc/fstab || \
  echo "UUID=$UUID $MNT ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null
sudo systemctl daemon-reload
mountpoint -q "$MNT" || sudo mount "$MNT"

# корень /data принадлежал пользователю (docker/ollama внутри — со своими владельцами, не трогаем)
[[ $(stat -c %U "$MNT") == "$USER" ]] || sudo chown "$USER:$USER" "$MNT"

echo "OK: $dev → $MNT"; df -h "$MNT" | tail -1; ls "$MNT"
