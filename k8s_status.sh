#!/bin/sh
set -e

kubectl version --output=yaml
kubectl cluster-info
kubectl get node