# ===============================
# Stage 0: Build NJOY
# ===============================
FROM python:3.12-slim AS njoy-builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        gfortran \
        build-essential \
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

# ===============================
# Stage 1: Binder-ready minimal image
# ===============================
FROM jupyter/minimal-notebook:python-3.12

# Copy NJOY binary and shared library
COPY --from=njoy-builder /NJOY2016/build/njoy /usr/local/bin/njoy
COPY --from=njoy-builder /NJOY2016/build/libnjoy.so /usr/local/lib/
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/njoy.conf \
    && ldconfig

ENV NJOY=/usr/local/bin/njoy

# Set working directory
WORKDIR /home/jovyan

# Minimal launch for Binder: no token/password for easy access
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]
