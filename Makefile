.PHONY: clean build

build:
	sudo docker build -f Dockerfile.v0.11.0rc0 -t eywalker/tensorflow:v0.11.0rc0-cuda8.0-cudnn5 .
	sudo docker build -f Dockerfile.v0.10.0 -t eywalker/tensorflow:v0.10.0-cuda8.0-cudnn5 .
	sudo docker build -f Dockerfile.v0.11.0 -t eywalker/tensorflow:v0.11.0-cuda8.0-cudnn5 .
	#sudo docker build -f Dockerfile.v0.12.0rc0 -t eywalker/tensorflow:v0.12.0rc0-cuda8.0-cudnn5 .
	sudo docker tag eywalker/tensorflow:v0.11.0rc0-cuda8.0-cudnn5 eywalker/tensorflow:cuda
	sudo docker build -t eywalker/tensorflow:v0.12.0rc0 .
	sudo docker tag eywalker/tensorflow:v0.12.0rc0 eywalker/tensorflow:latest

push:
	sudo docker push eywalker/tensorflow

