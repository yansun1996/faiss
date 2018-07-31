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
RUN apt-get install -y libopenblas-dev python-numpy python-dev swig git python-pip wget

RUN pip install matplotlib

COPY . /opt/faiss

WORKDIR /opt/faiss

ENV BLASLDFLAGS /usr/lib/libopenblas.so.0

RUN mv example_makefiles/makefile.inc.Linux ./makefile.inc

RUN make tests/test_blas -j $(nproc) && \
    make -j $(nproc) && \
    make demos/demo_sift1M -j $(nproc) && \
    make py

RUN cd gpu && \
    make -j $(nproc) && \
    make test/demo_ivfpq_indexing_gpu && \
    make py

ENV PYTHONPATH $PYTHONPATH:/opt/faiss

# RUN ./tests/test_blas && \
#     tests/demo_ivfpq_indexing


# RUN wget ftp://ftp.irisa.fr/local/texmex/corpus/sift.tar.gz && \
#     tar xf sift.tar.gz && \
#     mv sift sift1M

# RUN tests/demo_sift1M
