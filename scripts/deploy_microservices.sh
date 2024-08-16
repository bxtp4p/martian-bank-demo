#!/bin/bash

# Define the microservices and their directories
declare -A microservices=(
    ["accounts"]="accounts"
    ["atm-locator"]="atm-locator"
    ["customer-auth"]="customer-auth"
    ["dashboard"]="dashboard"
    ["loan"]="loan"
    ["transactions"]="transactions"
    ["ui"]="ui"
)

# Define the Docker registry
DOCKER_REGISTRY="localhost:5000"

# Build and push Docker images for each microservice
for service in "${!microservices[@]}"; do
    dir=../${microservices[$service]}
    echo "Building Docker image for $service..."
    docker build -t $DOCKER_REGISTRY/$service:latest $dir
    echo "Pushing Docker image for $service to local registry..."
    docker push $DOCKER_REGISTRY/$service:latest
done

# Deploy the services to the Kubernetes cluster using Helm
echo "Deploying services to Kubernetes cluster..."
helm install martianbank martianbank --set image.registry=$DOCKER_REGISTRY

# Verify that all pods are running
echo "Verifying that all pods are running..."
kubectl get pods

echo "Deployment completed successfully!"