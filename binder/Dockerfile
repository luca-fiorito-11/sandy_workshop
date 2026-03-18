# ===== Stage 1: Build NJOY =====
FROM python:3.12-slim AS njoy-builder

# System dependencies to build NJOY
RUN apt-get update && apt-get install -y --no-install-recommends \
    gfortran build-essential cmake git wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone and build NJOY2016
RUN git clone --depth 1 https://github.com/njoy/NJOY2016.git \
 && cd NJOY2016 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j$(nproc)

# ===== Stage 2: Binder environment =====
FROM python:3.12-slim

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libhdf5-dev libopenblas-dev mpich wget ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ===== Copy NJOY from builder =====
COPY --from=njoy-builder /NJOY2016/build/njoy /usr/local/bin/njoy
COPY --from=njoy-builder /NJOY2016/build/libnjoy.so /usr/local/lib/
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/njoy.conf \
 && ldconfig
ENV NJOY=/usr/local/bin/njoy

# ===== Python environment =====
# Minimal venv (optional)
# RUN python3 -m venv /opt/venv \
#  && /opt/venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel

# ===== Install Sandy and light dependencies =====
# For initial testing, comment out heavy packages
RUN python3 -m pip install --no-cache-dir \
    -i https://test.pypi.org/simple/ \
    --extra-index-url https://pypi.org/simple \
    sandy==1.2.0b1 \
    # numpy scipy matplotlib pandas h5py seaborn \
    # sandy serpentTools openmc_data_downloader openmc_depletion_plotter openmc_data \
    ipykernel jupyterlab

# Register Sandy kernel
RUN python3 -m ipykernel install --name "sandy" --display-name "Python (Sandy)"

# ===== Workspace =====
WORKDIR /home/jovyan
# USER jovyan  # uncomment if you create a non-root user

# ===== Jupyter =====
ENV PORT=8888
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
