#!/bin/bash
kubectl delete crd -n razee featureflagsetsld.kapitan.razee.io
kubectl delete crd -n razee managedsets.kapitan.razee.io
kubectl delete crd -n razee mustachetemplates.kapitan.razee.io
kubectl delete crd -n razee remoteresources.kapitan.razee.io
kubectl delete crd -n razee remoteresourcess3.kapitan.razee.io
