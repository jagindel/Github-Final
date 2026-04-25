#!/bin/bash

echo "Starting Minikube..."
minikube start --driver=docker

echo "Using Minikube Docker environment..."
eval $(minikube docker-env)

echo "Building Spring Boot jar..."
mvn clean package -DskipTests

echo "Building Docker image for webapp..."
docker build -t github-final:1.0 .

echo "Applying Kubernetes ConfigMap..."
kubectl apply -f k8s/mysql-configmap.yaml

echo "Applying Kubernetes PV and PVC..."
kubectl apply -f k8s/mysql-pv.yaml
kubectl apply -f k8s/mysql-pvc.yaml

echo "Applying MySQL deployment..."
kubectl apply -f k8s/mysql-deployment.yaml

echo "Applying Jenkins deployment..."
kubectl apply -f k8s/jenkins-deployment.yaml

echo "Applying Nexus deployment..."
kubectl apply -f k8s/nexus-deployment.yaml

echo "Applying webapp deployment..."
kubectl apply -f k8s/webapp-deployment.yaml

echo "Applying services..."
kubectl apply -f k8s/services.yaml

echo "Waiting for pods to start..."
sleep 20

echo "Checking ConfigMaps..."
kubectl get configmaps

echo "Checking PersistentVolumes..."
kubectl get pv

echo "Checking PersistentVolumeClaims..."
kubectl get pvc

echo "Checking Deployments..."
kubectl get deployments

echo "Checking Services..."
kubectl get services

echo "Checking Pods..."
kubectl get pods

echo "Deployment script finished."
echo "Webapp URL:"
minikube service webapp-service --url
