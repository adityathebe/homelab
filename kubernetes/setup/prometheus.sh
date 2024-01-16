#!/bin/bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring -f kubernetes/apps/monitoring/prometheus-community/values.yaml