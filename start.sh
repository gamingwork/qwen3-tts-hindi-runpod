#!/bin/bash
set -e

echo "=== Qwen3-TTS Hindi — RunPod startup ==="

cd /workspace/qwen3-tts-hindi

if [ -d "/runpod-volume" ]; then
    echo "Network volume detected — using it for model cache."
    export HF_HOME="/runpod-volume/hf-cache"
    mkdir -p "$HF_HOME"
fi

python - <<'PYEOF'
from huggingface_hub import snapshot_download
import os
print("Warming model cache (Qwen3-TTS-12Hz-1.7B-Base)...")
snapshot_download(
    repo_id="Qwen/Qwen3-TTS-12Hz-1.7B-Base",
    cache_dir=os.environ.get("HF_HOME", None),
)
print("Model cache ready.")
PYEOF

echo "Launching Gradio app on port 7860..."
python scripts/radio_app.py --model Qwen/Qwen3-TTS-12Hz-1.7B-Base --port 7860
