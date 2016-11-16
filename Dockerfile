# Tensorflow for CPU
FROM ubuntu:16.04
MAINTAINER Edgar Y. Walker <edgar.walker@gmail.com>

# Install essential Ubuntu packages and update pip
RUN apt-get update &&\
    apt-get install -y build-essential \
                       vim \
                       curl \
                       wget \
                       pkg-config \
                       libfreetype6-dev \
                       libssl-dev \
                       libreadline-dev \
                       libzmq3-dev \
                       libpng12-dev \
                       rsync \
                       unzip \
                       gfortran \
                       libblas-dev \
                       liblapack-dev \
                       python3-dev \
                       python3-pip &&\
    ln -s /usr/bin/python3 /usr/bin/python &&\
    ln -s /usr/bin/pip3 /usr/bin/pip &&\
    pip install --upgrade pip &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install essential Python packages
RUN pip3 --no-cache-dir install \
         numpy \
         matplotlib \
         scipy \
         pandas \
         jupyter \
         ipykernel &&\
    python -m ipykernel.kernelspec

# Set path to TensorFlow binary
ENV TF_BINARY_URL https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.11.0rc0-cp35-cp35m-linux_x86_64.whl

# Install TensorFlow
RUN pip --no-cache-dir install --upgrade $TF_BINARY_URL
