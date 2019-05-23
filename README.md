# kube-cloud-scripts

Bash utility scripts for kubectl and cloud providers.

| Script Prefix | Description        |
| ------------- | -----------        |
| ic            | IBM Cloud          |
| kc            | Kubernetes kubectl |

## ic_create_cluster.sh

Creates a cluster using IBM Cloud Kubernetes Service.  The script will
automatically figure out public and private VLANS for the region/zone used.

```bash
Required:
	--name <cluster-name>
Optional (defaults):
	--region us-east
	--zone wdc07
	--machine-type u2c.2x4
	--workers 2sh
```

## kc_create_razeedash_config.sh

Creates a kubernetes configmap razeedash-configmap in razee namespace

Example:

```bash
./bin/kc_create_razeedash_config.sh
```

## kc_delete_kapitan_delta.sh

Removes Kapitan delta from Kubernetes cluster.

Example:

```bash
./bin/kc_delete_kapitan_delta.sh
```

## kc_logs.sh

Fetches logs for all Kubernetes pods under namespace/application name for the last
duration in time.

`./bin/kc_logs.sh <namespace> <application name> <time duration>`

Example:

```bash
./bin/kc_logs.sh default myapp 10m
```
