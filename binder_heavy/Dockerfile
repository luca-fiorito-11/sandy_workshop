# ===== Stage 1: OpenMC builder =====
FROM python:3.12-slim AS openmc-builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        git cmake gfortran build-essential libhdf5-dev libopenblas-dev wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone and build OpenMC
RUN git clone --depth 1 https://github.com/openmc-dev/openmc.git \
    && cd openmc \
    && git fetch --tags \
    && git checkout v0.15.3 \
    && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DOPENMC_ENABLE_MPI=OFF -DOPENMC_USE_OPENMP=ON .. \
    && make -j$(nproc)

# Install OpenMC Python package
RUN cd openmc && pip install --no-cache-dir .

# ===== Stage 2: Main environment =====
FROM python:3.12-slim AS binder-env

# Install system packages for Python
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3-venv python3-pip libhdf5-dev libopenblas-dev mpich wget ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create virtualenv and install basic Python packages
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
    && /opt/venv/bin/pip install --no-cache-dir \
        ipykernel jupyterlab numpy scipy matplotlib pandas lxml h5py

# ===== Heavy packages (commented out for fast build) =====
# RUN /opt/venv/bin/pip install --no-cache-dir \
#         sandy serpentTools openmc_data_downloader openmc_depletion_plotter openmc_data

# Install OpenMC built in previous stage
COPY --from=openmc-builder /openmc/build/bin/openmc /usr/local/bin/openmc
COPY --from=openmc-builder /openmc/build/lib /usr/local/lib
COPY --from=openmc-builder /usr/local/lib/python3.12/site-packages/openmc /usr/local/lib/python3.12/site-packages/openmc

# Install Jupyter kernel
RUN /opt/venv/bin/python -m ipykernel install --name "sandy" --display-name "Python (Sandy)"

# Optional: strip binaries to reduce size
RUN strip /usr/local/bin/openmc || true

# Set working directory
WORKDIR /home/jovyan

# Expose Jupyter port
EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
