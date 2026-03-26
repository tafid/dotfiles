#!/bin/bash

# === Аргумент ===
if [ -z "$1" ]; then
  echo "❌ Укажи аудио или видеофайл, например: meeting.mp4"
  exit 1
fi

INPUT_FILE="$1"
BASENAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
TRANSCRIPT_FILE="${BASENAME}.txt"
SUMMARY_FILE="${BASENAME}.summary.txt"
MODEL="mistral"

# === Проверки ===
if ! command -v whisper &> /dev/null; then
  echo "❌ Whisper не установлен."
  exit 1
fi

if ! command -v ollama &> /dev/null; then
  echo "❌ ollama не установлен."
  exit 1
fi

# === Проверка доступной GPU-памяти через nvidia-smi ===
USE_GPU=true
if command -v nvidia-smi &> /dev/null; then
  FREE_MEM=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits | head -n 1)
  echo "🧠 Доступно GPU памяти: ${FREE_MEM} MB"
  if [ "$FREE_MEM" -lt 4000 ]; then
    echo "⚠️ Недостаточно GPU памяти, переключаемся на CPU..."
    USE_GPU=false
  else
    echo "✅ Достаточно GPU памяти, используем GPU"
  fi
else
  echo "⚠️ nvidia-smi не найден, используем CPU"
  USE_GPU=false
fi

# === Whisper (GPU или CPU) ===
echo "🎤 Транскрипция $INPUT_FILE..."
if [ "$USE_GPU" = false ]; then
  CUDA_VISIBLE_DEVICES="" whisper "$INPUT_FILE" \
    --language Ukrainian \
    --task transcribe \
    --model small \
    --output_format txt \
    --output_dir .
else
  whisper "$INPUT_FILE" \
    --language Ukrainian \
    --task transcribe \
    --model small \
    --output_format txt \
    --output_dir .
fi

# === Проверка результата ===
if [ ! -f "$TRANSCRIPT_FILE" ]; then
  echo "❌ Не найден транскрипт ($TRANSCRIPT_FILE)."
  exit 1
fi

# === Prompt для ollama ===
PROMPT=$(cat <<EOF
Сделай краткое, логичное и структурированное изложение следующей беседы. Выдели 5–15 ключевых пунктов. Язык текста — украинский или русский, сохраняй исходный язык.

$(cat "$TRANSCRIPT_FILE")
EOF
)

# === Генерация summary через ollama ===
echo "🧠 Генерация summary через модель $MODEL..."
echo "$PROMPT" | ollama run "$MODEL" > "$SUMMARY_FILE"

# === Финал ===
echo "✅ Готово!"
echo "📄 Транскрипт: $TRANSCRIPT_FILE"
echo "📝 Summary: $SUMMARY_FILE"
