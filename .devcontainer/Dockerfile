############################################
# Stage 1 — Build NJOY
############################################
FROM python:3.12-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    cmake \
    git \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/njoy/NJOY2016.git \
 && cd NJOY2016 \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j$(nproc)



############################################
# Stage 2 — Devcontainer runtime
############################################
FROM mcr.microsoft.com/devcontainers/python:3.12 AS dev_containers_target_stage

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

############################################
# System dependencies (minimal but sufficient)
############################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    cmake \
    git \
    libhdf5-dev \
    libopenblas-dev \
    mpich \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

############################################
# Python environment
############################################
RUN python3 -m venv $VIRTUAL_ENV \
 && pip install --upgrade pip setuptools wheel

############################################
# Install Python stack (grouped for caching)
############################################
RUN pip install \
    numpy scipy pandas matplotlib h5py lxml

RUN pip install \
    openmc \
    sandy \
    serpentTools

RUN pip install \
    scikit-learn seaborn \
    jupyterlab ipykernel

RUN python -m ipykernel install \
    --name "sandy" \
    --display-name "Python (Sandy)"

############################################
# Copy NJOY binary only
############################################
COPY --from=builder /NJOY2016/build/njoy /usr/local/bin/njoy

RUN ldconfig

############################################
# Devcontainer user setup
############################################
WORKDIR /home/vscode
RUN chown -R vscode:vscode /opt/venv /home/vscode

USER vscode

############################################
# Jupyter
############################################
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
