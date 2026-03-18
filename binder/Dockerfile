# ===== Stage 1: Build NJOY =====
FROM python:3.12-slim AS njoy-builder

# Build dependencies for NJOY
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    cmake \
    git \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone and build NJOY2016
RUN git clone --depth 1 https://github.com/njoy/NJOY2016.git \
 && cd NJOY2016 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j$(nproc)

# ===== Stage 2: Binder environment =====
FROM python:3.12-slim AS binder-env

# System packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-venv \
    libhdf5-dev libopenblas-dev \
    wget ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create virtual environment
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python3 -m venv $VIRTUAL_ENV

# Upgrade pip and install Python packages
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir \
    ipykernel notebook \
    numpy scipy matplotlib pandas seaborn h5py \
    --extra-index-url https://test.pypi.org/simple/ sandy==1.2.0b1

# Register Sandy kernel
RUN python -m ipykernel install --name "sandy" --display-name "Python (Sandy)"

# Copy NJOY binary + shared library from builder stage
COPY --from=njoy-builder /NJOY2016/build/njoy /usr/local/bin/njoy
COPY --from=njoy-builder /NJOY2016/build/libnjoy.so /usr/local/lib/
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/njoy.conf \
 && ldconfig
ENV NJOY=/usr/local/bin/njoy

# Set working directory
WORKDIR /home/jovyan

# Expose Jupyter port
EXPOSE 8888

# Run Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
