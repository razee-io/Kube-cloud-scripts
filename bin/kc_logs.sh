#!/bin/bash
: '
Copyright 2019 IBM Corp. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
'
NAMESPACE=$1
APP=$2
TIME_SINCE=$3
DATE=$(date +"%m.%d.%y-%R")


if [[ -z "$NAMESPACE" ]] || [[ -z $APP ]] || [[ -z $TIME_SINCE ]]; then
	echo "${0} <namespace> <application name> <time duration>"
	echo ""
	echo "Fetches logs of all kubernetes pods for a given namespace/application"
	echo "name for the last duration of time."
	echo ""
	echo "Example:"
	echo "	${0} default myapp 10m"
  echo "exiting"
  exit 1
fi
#printing cluster-info
kubectl cluster-info

#printing pod info
echo "Attempting to find PODS for namesapce $NAMESPACE and app $APP"

kubectl get pods -n "${NAMESPACE}" --selector=app="${APP}" | grep "${APP}"
RC=$?

if [[ $RC != 0 ]]; then
  echo "error detected finding the pods, exiting"
  exit 1
fi

echo "Downloading logs for the PODS - outputting to $LOG_DIR/${APP}_${NAMESPACE}_${DATE}.log"
echo "Depending on the time since setting, this may take a few moments"

for i in $(kubectl get pods -n "${NAMESPACE}" --selector=app="${APP}" | grep "${APP}" | awk '{print $1}');
do
	kubectl logs "${i}" -n "${NAMESPACE}" --since "${TIME_SINCE}";
done
