#!/bin/bash

# Start Docker service
sudo service docker start

# Start Minikube
minikube start --driver=docker

# Set up kubectl context
kubectl config use-context minikube