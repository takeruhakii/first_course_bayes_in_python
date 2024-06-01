# 最初に構築したイメージと合わせる
FROM python:3.11-slim

# お好みで好きなパッケージを追加
RUN apt-get update && apt-get install -y \
    build-essential \
    graphviz \
    git \
    curl \
    wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home
RUN wget https://github.com/stan-dev/httpstan/archive/refs/tags/4.12.0.tar.gz && \
    tar -xvf 4.12.0.tar.gz && \
    cd httpstan-4.12.0 && \
    make && \
    pip install poetry && \
    poetry config virtualenvs.create false && \
    python3 -m poetry build

WORKDIR /app

RUN git config --global --add safe.directory /app  

COPY ./pyproject.toml ./poetry.lock* ./

RUN poetry update
RUN poetry add pymc && \
    poetry add pystan