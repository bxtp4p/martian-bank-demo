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

# Start the local Docker registry if it's not already running
if ! docker ps | grep -q "registry"; then
    echo "Starting local Docker registry..."
    docker run -d -p 5000:5000 --name registry registry:2
fi

# Build and push Docker images for each microservice
for service in "${!microservices[@]}"; do
    dir=./${microservices[$service]}
    echo "Building Docker image for $service..."
    docker build -t $DOCKER_REGISTRY/$service:latest -f $dir/Dockerfile .
    echo "Pushing Docker image for $service to local registry..."
    docker push $DOCKER_REGISTRY/$service:latest
done

# Deploy the services to the Kubernetes cluster using Helm
echo "Deploying services to Kubernetes cluster..."

# Check if the release is already deployed
if helm status martianbank >/dev/null 2>&1; then
    echo "Updating existing deployment..."
    helm upgrade martianbank martianbank --set image.registry=$DOCKER_REGISTRY
else
    echo "Deploying new services..."
    helm install martianbank martianbank --set image.registry=$DOCKER_REGISTRY
fi

# Verify that all pods are running
echo "Verifying that all pods are running..."
kubectl get pods

echo "Deployment completed successfully!"