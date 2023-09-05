#!/bin/bash

# For more information, see:
# https://kubernetes.github.io/ingress-nginx/user-guide/monitoring/#configure-prometheus
# https://github.com/kubernetes/ingress-nginx/tree/main/deploy/grafana/dashboards
# https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config
# https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-scrape-configuration

# Deploy ConfigMap
kubectl apply -n kube-system -f ama-metrics-prometheus-config-configmap.yaml
