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
RUN apt-get update && \
    apt-get install -y curl bzip2  && \
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh > /tmp/conda.sh && \
    bash /tmp/conda.sh -b -p /opt/conda && \
    /opt/conda/bin/conda update -n base conda && \
    /opt/conda/bin/conda install faiss-gpu -c pytorch && \
    apt-get remove -y --auto-remove curl bzip2 && \
    apt-get clean && \
    rm -fr /tmp/conda.sh

ENV PATH="/opt/conda/bin:${PATH}"

ENV PYTHONPATH "$PYTHONPATH:/opt/faiss"
