# Dockerfile with tensorflow gpu support. Install CV related packages.
FROM nvidia/cuda:8.0-devel-ubuntu16.04
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

# Install faiss
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda2-4.5.4-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get update && \
    apt-get install -y curl bzip2  && \
    conda update -n base conda && \
    conda install faiss-gpu -c pytorch && \
    conda install -c anaconda tensorflow-gpu==1.4.1 && \
    apt-get remove -y --auto-remove curl bzip2 && \
    apt-get clean && \
    rm -fr /tmp/conda.sh

ENV PATH="/opt/conda/bin:${PATH}"

ENV PYTHONPATH "$PYTHONPATH:/opt/faiss"

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
