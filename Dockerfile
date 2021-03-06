# Build TensorFlow for CPU
FROM ubuntu:16.04
MAINTAINER Edgar Y. Walker <edgar.walker@gmail.com>

# Install essential Ubuntu packages, Oracle Java 8,
# and upgrade pip
RUN apt-get update &&\
    apt-get install -y software-properties-common \
                       build-essential \
                       git \
                       wget \
                       vim \
                       curl \
                       zip \
                       zlib1g-dev \
                       unzip \ 
                       pkg-config \
                       libblas-dev \
                       liblapack-dev \
                       python-dev \
                       python3-dev \
                       python3-pip \
                       python3-tk \
                       python3-wheel \
                       swig &&\
    add-apt-repository -y ppa:webupd8team/java && apt-get update &&\
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections &&\
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections &&\
    apt-get install -y oracle-java8-installer &&\
    ln -s /usr/bin/python3 /usr/local/bin/python &&\
    ln -s /usr/bin/pip3 /usr/local/bin/pip &&\
    pip install --upgrade pip &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /src

# Install Bazel from source
ARG BAZEL_VER=0.4.3
ENV BAZEL_VER $BAZEL_VER
ENV BAZEL_INSTALLER bazel-$BAZEL_VER-installer-linux-x86_64.sh
ENV BAZEL_URL https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VER/$BAZEL_INSTALLER
RUN wget $BAZEL_URL &&\
    wget $BAZEL_URL.sha256 &&\
    sha256sum -c $BAZEL_INSTALLER.sha256 &&\
    chmod +x $BAZEL_INSTALLER &&\
    ./$BAZEL_INSTALLER &&\
    rm /src/*

# Install essential Python packages
RUN pip3 --no-cache-dir install \
         numpy \
         matplotlib \
         scipy \
         pandas \
         jupyter \
         scikit-learn \
         seaborn
          
ARG TF_TAG=v1.0.0-rc0
ENV TF_TAG $TF_TAG

# Get TensorFlow
RUN git clone https://github.com/tensorflow/tensorflow &&\
    cd tensorflow &&\
    git checkout tags/$TF_TAG

# Set env variables for configure script
ENV PYTHON_BIN_PATH="/usr/bin/python3" TF_NEED_GCP=0 TF_NEED_CUDA=0 TF_NEED_HDFS=1 USE_DEFAULT_PYTHON_LIB_PATH=1 TF_NEED_OPENCL=0 CC_OPT_FLAGS="-march=native" TF_NEED_JEMALLOC=1 TF_ENABLE_XLA=0

RUN cd tensorflow &&\
    sed -i "s#zlib.net/zlib-#zlib.net/fossils/zlib-#g" tensorflow/workspace.bzl &&\
    ./configure &&\
    bazel build -c opt //tensorflow/tools/pip_package:build_pip_package &&\
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg &&\
    pip3 install /tmp/tensorflow_pkg/tensorflow-*.whl &&\
    cd .. &&\
    rm -rf tensorflow
