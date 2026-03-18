############################################
# Stage 1 — Build NJOY
############################################
FROM python:3.12-slim AS njoy-builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gfortran cmake git wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/njoy/NJOY2016.git \
 && cd NJOY2016 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j$(nproc)

############################################
# Stage 1b — Build OpenMC
############################################
FROM python:3.12-slim AS openmc-builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    gfortran cmake git build-essential libhdf5-dev libopenblas-dev wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/openmc-dev/openmc.git \
 && cd openmc \
 && git fetch --tags \
 && git checkout v0.15.3 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release -DOPENMC_ENABLE_MPI=OFF -DOPENMC_USE_OPENMP=ON .. \
 && make -j$(nproc)

# Install Python OpenMC package in builder stage
RUN cd openmc && pip install --no-cache-dir .

############################################
# Stage 2 — Runtime Devcontainer
############################################
FROM python:3.12-slim

############################################
# System dependencies (runtime only)
############################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-venv python3-pip libhdf5-dev libopenblas-dev mpich wget ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

############################################
# Environment
############################################
ARG NB_USER=vscode
ARG NB_UID=1000
ENV USER=${NB_USER} \
    HOME=/home/${NB_USER} \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH" \
    LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

############################################
# Python environment
############################################
RUN python3 -m venv $VIRTUAL_ENV \
 && pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir ipykernel jupyterlab \
 && pip install --no-cache-dir \
    numpy scipy matplotlib pandas lxml h5py \
    sandy serpentTools openmc_data_downloader openmc_depletion_plotter openmc_data

# Register Sandy kernel
RUN python3 -m ipykernel install --name "sandy" --display-name "Python (Sandy)"

############################################
# Copy OpenMC binaries + Python package from builder
############################################
COPY --from=openmc-builder /openmc/build/bin/openmc /usr/local/bin/openmc
COPY --from=openmc-builder /openmc/build/lib /usr/local/lib
COPY --from=openmc-builder /usr/local/lib/python3.12/site-packages/openmc /usr/local/lib/python3.12/site-packages/openmc

############################################
# Copy NJOY binary + shared library
############################################
COPY --from=njoy-builder /NJOY2016/build/njoy /usr/local/bin/njoy
COPY --from=njoy-builder /NJOY2016/build/libnjoy.so /usr/local/lib/
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/njoy.conf && ldconfig
ENV NJOY=/usr/local/bin/njoy

############################################
# Workspace (fast ownership using COPY --chown)
############################################
WORKDIR /home/vscode
# COPY --chown=${NB_UID}:${NB_UID} Datalabs/ /home/vscode/Datalabs/
# COPY --chown=${NB_UID}:${NB_UID} Extra/ /home/vscode/Extra/
# COPY --chown=${NB_UID}:${NB_UID} data/ /home/vscode/data/

USER ${NB_USER}

############################################
# Jupyter
############################################
ENV PORT=8888
EXPOSE 8888
CMD ["jupyter", "lab", "--notebook-dir=/home/vscode/", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
