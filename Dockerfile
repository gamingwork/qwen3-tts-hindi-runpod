FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

# --- System deps ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ffmpeg \
    libsndfile1 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# --- Clone the Hindi fine-tuned Qwen3-TTS pipeline ---
# Repo: https://huggingface.co/saumilyajj/Qwen3-TTS-12Hz-1.7B-Base-hindi-ft
RUN git clone https://huggingface.co/saumilyajj/Qwen3-TTS-12Hz-1.7B-Base-hindi-ft /workspace/qwen3-tts-hindi

WORKDIR /workspace/qwen3-tts-hindi

# --- Python deps ---
RUN pip install --no-cache-dir -r requirements.txt || echo "No requirements.txt found, check repo structure"
RUN pip install --no-cache-dir bitsandbytes gradio

COPY start.sh /workspace/start.sh
RUN chmod +x /workspace/start.sh

EXPOSE 7860

CMD ["/workspace/start.sh"]
