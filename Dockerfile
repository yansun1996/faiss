# Dockerfile with tensorflow gpu support. Install CV related packages.
FROM tensorflow/tensorflow:1.4.0-gpu
MAINTAINER Yan Sun <sunyanfred@163.com>

# The code below is all based off the repos made by https://github.com/janza/
# He makes great dockerfiles for opencv, I just used a different base as I need
# tensorflow on a gpu.

RUN apt-get update

# Core linux dependencies. 
RUN apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libavformat-dev \
        libhdf5-dev \
        libpq-dev \
        python-pip \
        python-dev \
        libsm6 \
        libxrender1 \
        libxext-dev \
        vim \
        zip

# Update pip
RUN pip install --upgrade pip

# Python dependencies
RUN pip install \
    numpy \
    hdf5storage \
    h5py \
    scipy \
    py3nvml \
    scikit-learn \
    psutil \
    Pillow \
    matplotlib \
    requests \
    opencv-python
    
# Update h5py
RUN pip install h5py --upgrade

# Install faiss
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y libopenblas-dev python-numpy python-dev swig git python-pip wget vim python-tk
RUN apt-get -y autoremove
RUN apt-get clean

RUN pip install --no-cache-dir --upgrade --ignore-installed pip
RUN pip install cython matplotlib pandas jupyter sklearn scipy

# Pre-populate font list to avoid warning on first import of matplotlib.pyplot
RUN python -c "import matplotlib.pyplot"

WORKDIR /opt
RUN git clone --depth=1 https://github.com/facebookresearch/faiss
WORKDIR /opt/faiss

ENV BLASLDFLAGS /usr/lib/libopenblas.so.0

RUN mv example_makefiles/makefile.inc.Linux ./makefile.inc

RUN make tests/test_blas -j $(nproc) && \
    make -j $(nproc) && \
    make tests/demo_sift1M -j $(nproc)

RUN make py

RUN cd gpu && \
    make -j $(nproc) && \
    make test/demo_ivfpq_indexing_gpu && \
    make py

RUN echo "export PYTHONPATH=\$PYTHONPATH:/opt/faiss" >> ~/.bashrc
ENV PYTHONPATH "$PYTHONPATH:/opt/faiss"
