#!/usr/bin/env bash

mkdir /tensorboard
tensorboard --logdir=/tensorboard/ &
jupyter notebook "$@"
