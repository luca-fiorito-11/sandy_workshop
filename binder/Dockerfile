# ===== Stage 1: NJOY builder =====
FROM python:3.12-slim AS njoy-builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        git cmake gfortran build-essential wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone and build NJOY
RUN git clone --depth 1 https://github.com/njoy/NJOY2016.git \
    && cd NJOY2016 \
    && git fetch --tags \
    && git checkout v2016.61 \
    && mkdir build && cd build \
    && cmake .. \
    && make -j$(nproc)

# ===== Stage 2: Main environment =====
FROM python:3.12-slim AS binder-env

# Install system packages for Python
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3-venv python3-pip libhdf5-dev mpich wget ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create virtualenv and install basic Python packages
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
    && /opt/venv/bin/pip install --no-cache-dir \
        ipykernel jupyterlab numpy scipy matplotlib pandas lxml h5py seaborn

# ===== Heavy packages (optional) =====
# RUN /opt/venv/bin/pip install --no-cache-dir sandy openmc_data_downloader openmc_depletion_plotter

# Install Sandy
RUN /opt/venv/bin/pip install --no-cache-dir sandy

# Copy NJOY binaries from previous stage
COPY --from=njoy-builder /NJOY2016/build/njoy /usr/local/bin/njoy
COPY --from=njoy-builder /NJOY2016/build/libnjoy.so /usr/local/lib/

# Configure linker for NJOY
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/njoy.conf && ldconfig

# Optional: strip NJOY binary to reduce size
RUN strip /usr/local/bin/njoy || true

# Install Jupyter kernel
RUN /opt/venv/bin/python -m ipykernel install --name "sandy" --display-name "Python (Sandy)"

# Set working directory
WORKDIR /home/jovyan

# Expose Jupyter port
EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
