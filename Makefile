.PHONY: clean build
cpu-v0.11.0rc0:
	sudo docker build -t eywalker/tensorflow:v0.11.0rc0 --build-arg TF_TAG=v0.11.0rc0 --build-arg BAZEL_VER=0.3.1 .

cuda-v0.11.0rc0:
	sudo docker build -f Dockerfile.cuda -t eywalker/tensorflow:v0.11.0rc0-cuda8.0-cudnn5 --build-arg TF_TAG=v0.11.0rc0 --build-arg BAZEL_VER=0.3.1 .

cpu-v0.12.1:
	sudo docker build -t eywalker/tensorflow:v0.12.1 --build-arg TF_TAG=0.12.1 .

cuda-v0.12.1:
	sudo docker build -f Dockerfile.cuda -t eywalker/tensorflow:v0.12.1-cuda8.0-cudnn5 --build-arg TF_TAG=0.12.1 .

cpu-v1.0.0rc0:
	sudo docker build -t eywalker/tensorflow:v1.0.0rc0 --build-arg TF_TAG=v1.0.0-rc0 .

cuda-v1.0.0rc0:
	sudo docker build -f Dockerfile.cuda -t eywalker/tensorflow:v1.0.0rc0-cuda8.0-cudnn5 --build-arg TF_TAG=v1.0.0-rc0 .

cuda-v1.0.1:
	sudo docker build -f Dockerfile.pip -t eywalker/tensorflow:v1.0.1-cuda8.0-cudnn5 .

latest: cpu-v0.12.1
	sudo docker tag eywalker/tensorflow:v0.12.1 eywalker/tensorflow:latest

cuda: cuda-v0.12.1
	sudo docker tag eywalker/tensorflow:v0.12.1-cuda8.0-cudnn5 eywalker/tensorflow:cuda

build: cpu-v0.12.1 cuda-v0.12.1 cpu-v1.0.0rc0 cuda-v1.0.0rc0 cuda-v1.0.1 cuda latest

push:
	sudo docker push eywalker/tensorflow:v0.12.1
	sudo docker push eywalker/tensorflow:v0.12.1-cuda8.0-cudnn5
	sudo docker push eywalker/tensorflow:v1.0.0rc0
	sudo docker push eywalker/tensorflow:v1.0.0rc0-cuda8.0-cudnn5
	sudo docker push eywalker/tensorflow:v1.0.1-cuda8.0-cudnn5
	sudo docker push eywalker/tensorflow:latest
	sudo docker push eywalker/tensorflow:cuda


