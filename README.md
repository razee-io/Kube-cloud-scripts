# kube-cloud-scripts

Bash utility scripts for kubectl and cloud providers.

## ic_create_cluster.n/ic_create_cluster.sh

Creates a cluster using IBM Cloud Kubernetes Service.  The script will
automatically figure out public and private VLANS for the region/zone used.

Required:
	--name <cluster-name>
Optional (defaults):
	--region us-east
	--zone wdc07
	--machine-type u2c.2x4
	--workers 2sh

## kc_logs.sh

Fetches logs for all Kubernetes pods under namespace/application name for the last
duration in time.

./bin/kc_logs.sh <namespace> <application name> <time duration>

Example:
	./bin/kc_logs.sh default myapp 10m
