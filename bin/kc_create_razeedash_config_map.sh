#!/bin/bash
RAZEEDASH_LB=$(kubectl get service razeedash-lb -n razee -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
RAZEEDASH_API_LB=$(kubectl get service razeedash-api-lb -n razee -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
kubectl create configmap razeedash-config -n razee \
	--from-literal=root_url=http://"${RAZEEDASH_LB}":8080/ \
	--from-literal=razeedash_api_url=http://"${RAZEEDASH_API_LB}":8081/
