# Melhor imagem para SoccerNet GameState: PyTorch com CUDA
FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-devel

# Configurar Python e sistema
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependências
COPY pyproject.toml uv.lock ./

# Instalar UV (gerenciador de pacotes Python rápido)
RUN pip install uv

# Instalar dependências do projeto
RUN uv pip install --system -e .

# Instalar MMCV separadamente (pode ser problemático)
RUN uv pip install --system mmcv==2.0.1 -f https://download.openmmlab.com/mmcv/dist/cu121/torch2.1/index.html

# Copiar código do projeto
COPY . .

# Criar diretórios necessários
RUN mkdir -p data outputs pretrained_models

# Expor porta se necessário
EXPOSE 8000

# Variáveis de ambiente para CUDA
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Comando padrão
CMD ["uv", "run", "tracklab", "-cn", "soccernet"] 