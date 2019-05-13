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
echo "Starting script $0"

usage() {
	echo "$0"
	echo ""
	echo "Creates a cluster using IBM Cloud Kubernetes Service.  The script will"
	echo "Will figure out public and private VLANS for the region/zone used."
	echo ""
	echo "Required:"
	echo "	--name <cluster-name>"
	echo "Optional (defaults):"
	echo "	--region us-east"
	echo "	--zone wdc07"
	echo "	--machine-type u2c.2x4"
	echo "	--workers 2"
	echo ""
}

raise_error() {
	local error_message="${*}"
	echo "${error_message}" 1>&2;
}

REGION=us-east
ZONE=wdc07
MACHINETYPE=u2c.2x4
WORKERS=2

while (( "$#" )); do
	case "$1" in
		-h | --help)
			usage
			exit
			;;
		--region)
			REGION=${2}
			shift 2
			;;
		--zone)
			ZONE=${2}
			shift 2
			;;
		--machine-type)
			MACHINETYPE=${2}
			shift 2
			;;
		--workers)
			WORKERS=${2}
			shift 2
			;;
		--name)
			NAME=${2}
			shift 2
			;;
		--)
			shift
			break
			;;
		--*=)
			raise_error "ERROR: unknown parameter \"${1}\""
			usage
			exit 1
			;;
		*)
			shift
			;;
	esac
done

if [ "${NAME}" == "" ]; then
	raise_error "ERROR: cluster name not specified"
	usage
	exit 1
fi

ibmcloud ks region-set --region "${REGION}"
public_vlan=$(ibmcloud ks vlans "${ZONE}" --json | jq -c '.[] |  select( .properties.name | contains("Cruiser")) | select( .type | contains("public"))' | jq .id | sed -e 's/"//g')
private_vlan=$(ibmcloud ks vlans "${ZONE}" --json | jq -c '.[] |  select( .properties.name | contains("Cruiser")) | select( .type | contains("private"))' | jq .id | sed -e 's/"//g')
if [[ -z "${public_vlan}"  &&  -z "${private_vlan}" ]]; then
	public_vlan=$(ibmcloud ks vlans "${ZONE}" --json | jq -c '.[] |  select( .type | contains("public"))' | jq .id | sed -e 's/"//g')
	private_vlan=$(ibmcloud ks vlans "${ZONE}" --json | jq -c '.[] |  select( .type | contains("private"))' | jq .id | sed -e 's/"//g')
	if [[ -z "${public_vlan}"  &&  -z "${private_vlan}" ]]; then
		# No vlans exists so create cluster will automatically create them
		echo "ibmcloud ks cluster-create --name ${NAME} --zone ${ZONE} --machine-type ${MACHINETYPE} --workers ${WORKERS}"
		ibmcloud ks cluster-create \
			--name "${NAME}" \
			--zone "${ZONE}" \
			--machine-type "${MACHINETYPE}" \
			--workers "${WORKERS}"
		exit 0
	fi
fi
# create cluster with existing vlans
echo "ibmcloud ks cluster-create --name ${NAME} --zone ${ZONE} --machine-type ${MACHINETYPE} --workers ${WORKERS} --public-vlan ${public_vlan} --private-vlan ${private_vlan}"
ibmcloud ks cluster-create \
	--name "${NAME}" \
	--zone "${ZONE}" \
	--machine-type "${MACHINETYPE}" \
	--workers "${WORKERS}" \
	--public-vlan "${public_vlan}" \
	--private-vlan "${private_vlan}"
exit 0
