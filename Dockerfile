# Tensorflow supports only upto CUDNN v4
FROM nvidia/cuda:7.5-cudnn4-devel
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
ENV TF_BINARY_URL https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.10.0rc0-cp34-cp34m-linux_x86_64.whl


# Install TensorFlow
RUN pip --no-cache-dir install --upgrade $TF_BINARY_URL

# Expose port for TensorBoard
EXPOSE 6006

# Expose port for Jupyter Notebook
EXPOSE 8888

# Hack to deal with weird bug that prevents running `jupyter notebook` directly
# from Docker ENTRYPOINT or CMD. 
# Use dumb shell script that runs `jupyter notebook` :(
# https://github.com/ipython/ipython/issues/7062
ADD run_tensorflow.sh /

# Add Jupyter Notebook config
ADD jupyter_notebook_config.py /root/.jupyter/

WORKDIR /notebooks

ENTRYPOINT ["/run_tensorflow.sh"]
