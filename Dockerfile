# ベースイメージ
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

# 必要なツールをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-dev python3-venv \
    build-essential git wget curl \
    libgl1 libglib2.0-0 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# pipを最新化
RUN python3 -m pip install --upgrade pip setuptools wheel

# 必要なPythonライブラリをインストール
# PyPIをデフォルトのインデックスとして利用し、PyTorchのインデックスを後から指定
RUN pip install \
    jupyterlab \
    numpy pandas matplotlib seaborn && \
    pip install \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip install ultralytics

# JupyterLabの設定
RUN mkdir -p /workspace
WORKDIR /workspace

# JupyterLabの起動スクリプトを追加
RUN echo '#!/bin/bash\njupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password=""' > /start.sh
RUN chmod +x /start.sh

# コンテナ起動時のエントリポイント
CMD ["/start.sh"]
