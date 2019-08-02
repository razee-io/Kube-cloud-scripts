#!/bin/bash
RAZEEDASH_LB_IP=$(kubectl get service razeedash-lb -n razee -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
RAZEEDASH_API_LB_IP=$(kubectl get service razeedash-api-lb -n razee -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
RAZEEDASH_LB_HOSTNAME=$(kubectl get service razeedash-lb -n razee -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")
RAZEEDASH_API_LB_HOSTNAME=$(kubectl get service razeedash-api-lb -n razee -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")
RAZEEDASH_LB=${RAZEEDASH_LB_HOSTNAME} && [[ "${RAZEEDASH_LB_IP}" != "" ]] && RAZEEDASH_LB=${RAZEEDASH_LB_IP}
RAZEEDASH_API_LB=${RAZEEDASH_LB_API_HOSTNAME} && [[ "${RAZEEDASH_LB_API_IP}" != "" ]] && RAZEEDASH_API_LB=${RAZEEDASH_LB_API_IP}
kubectl create configmap razeedash-config -n razee \
    --from-literal=root_url=http://"${RAZEEDASH_LB}":8080/ \
    --from-literal=razeedash_api_url=http://"${RAZEEDASH_API_LB}":8081/
