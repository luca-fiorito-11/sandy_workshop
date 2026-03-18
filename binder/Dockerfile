# ===== Stage 1: NJOY builder =====
FROM python:3.12-slim AS njoy-builder

# Build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    cmake \
    git \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Build NJOY2016
RUN git clone --depth 1 https://github.com/njoy/NJOY2016.git \
 && cd NJOY2016 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j$(nproc)

# ===== Stage 2: Main environment =====
FROM python:3.12-slim AS binder-env

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-venv \
    python3-pip \
    libhdf5-dev \
    libopenblas-dev \
    wget \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create virtualenv and install Python packages
RUN python3 -m venv /opt/venv \
 && /opt/venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
 && /opt/venv/bin/pip install --no-cache-dir \
    jupyterlab \
    ipykernel \
    numpy \
    scipy \
    pandas \
    matplotlib \
    seaborn \
    sandy

# Copy NJOY binaries for Sandy
COPY --from=njoy-builder /NJOY2016/build/bin/* /usr/local/bin/

# Install Jupyter kernel
RUN /opt/venv/bin/python -m ipykernel install --name "sandy" --display-name "Python (Sandy)"

# Set working directory
WORKDIR /home/jovyan

# Expose Jupyter port
EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
