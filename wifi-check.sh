#!/usr/bin/env bash
# Диагностика Wi-Fi: линк, задержка до роутера, сканы DMS, скорость загрузки.
# Использование: ./wifi-check.sh [--fix]   (--fix: перезапустить dms, если он спамит сканами)
set -u
IF=$(iw dev | awk '/Interface/{print $2; exit}')
GW=$(ip route | awk '/default/{print $3; exit}')

echo "== линк ($IF)"
iw dev "$IF" link | grep -E 'Connected|freq|signal|bitrate'

echo "== пинг до роутера $GW (30 с)"
ping -i 0.2 -c 150 -q "$GW" | tail -1

echo "== сканы Wi-Fi за 30 с (норма: 0)"
SCANS=$(timeout 30 iw event -t 2>&1 | grep -c 'scan started')
echo "$SCANS"

echo "== загрузка (50 МБ, cloudflare)"
curl -s -o /dev/null -w '%{speed_download}\n' --max-time 20 'https://speed.cloudflare.com/__down?bytes=50000000' \
  | awk '{printf "%.1f МБ/с (~%d Мбит/с)\n", $1/1e6, $1*8/1e6}'

if [ "$SCANS" -gt 0 ]; then
  echo "!! DMS сканирует Wi-Fi (утёкший addRef в NetworkService) — это даёт скачки задержки."
  if [ "${1:-}" = "--fix" ]; then
    systemctl --user restart dms && echo "dms перезапущен"
  else
    echo "   Запусти с --fix, чтобы перезапустить dms."
  fi
fi
