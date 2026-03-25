############################################
# Stage 1 — Build NJOY
############################################
FROM python:3.12-slim AS builder

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

############################################
# Stage 2 — Devcontainer
############################################
FROM mcr.microsoft.com/devcontainers/base:bookworm

############################################
# System dependencies
############################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-venv \
    build-essential \
    gfortran \
    g++ \
    cmake \
    git \
    libhdf5-dev \
    libopenblas-dev \
    mpich \
    wget \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

############################################
# Environment
############################################
ARG NB_USER=vscode
ARG NB_UID=1000
ENV USER=${NB_USER} \
    HOME=/home/${NB_USER} \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

############################################
# Python environment
############################################
RUN python3 -m venv $VIRTUAL_ENV \
 && pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir \
    ipykernel jupyterlab nbconvert \
    numpy scipy matplotlib pandas lxml h5py seaborn papermill\
    --index-url https://test.pypi.org/simple/ \
    --extra-index-url https://pypi.org/simple \
    sandy==1.2.0b1 \
    serpentTools openmc_data_downloader openmc_depletion_plotter openmc_data

# Register Sandy kernel
RUN python3 -m ipykernel install --name "sandy" --display-name "Python (Sandy)"

############################################
# Build + install OpenMC
############################################
RUN git clone --depth 1 https://github.com/openmc-dev/openmc.git \
 && cd openmc \
 && git fetch --tags \
 && git checkout v0.15.3 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release \
          -DOPENMC_ENABLE_MPI=OFF \
          -DOPENMC_USE_OPENMP=ON \
          .. \
 && make -j$(nproc) \
 && make install \
 && cd .. \
 && pip install .

############################################
# Copy NJOY binary + shared library
############################################
COPY --from=builder /NJOY2016/build/njoy /usr/local/bin/njoy
COPY --from=builder /NJOY2016/build/libnjoy.so /usr/local/lib/
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/njoy.conf \
 && ldconfig
ENV NJOY=/usr/local/bin/njoy

# Prepare workspace and copy files
WORKDIR ${HOME}
COPY --chown=${NB_UID}:${NB_UID} Exercises/ ${HOME}/Exercises/
COPY --chown=${NB_UID}:${NB_UID} openmc_data/ ${HOME}/openmc_data/

############################################
# Workspace
############################################
WORKDIR /home/vscode
RUN chown -R ${NB_UID}:${NB_UID} /opt/venv /home/vscode
USER ${NB_USER}

############################################
# Jupyter
############################################
ENV PORT=8888
EXPOSE 8888
CMD ["jupyter", "lab", "--notebook-dir=/home/vscode/", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
