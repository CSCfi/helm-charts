# Rocket.Chat

> [!IMPORTANT]  
> Since on 29 September 2025, Bitnami has changed its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images have been moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images are available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)  
> - Some of our Helm Charts used `Bitnami` images. We migrated most of the important images to the CSC Container Registry [Satama](https://satama.csc.fi).  
> - Be mindful when deploying these charts in your production environment.  

[Rocket.Chat](https://rocket.chat/) is free, unlimited and open source. Replace email, HipChat & Slack with the ultimate team chat software solution.

> **WARNING**: This deployment is meant for CSC Rahti platform and based on the original version that you can find here: https://github.com/RocketChat/helm-charts/

## Introduction

This chart bootstraps a [Rocket.Chat](https://rocket.chat/) Deployment on a [OKD](https://okd.io) cluster using the [Helm](https://helm.sh) package manager. It provisions a fully featured Rocket.Chat installation.

In addition, this chart supports scaling of Rocket.Chat for increased server capacity and high availability (requires enterprise license).  For more information on Rocket.Chat and its capabilities, see its [documentation](https://rocket.chat/docs/).

## Prerequisites Details

The chart has an optional dependency on the [MongoDB](https://github.com/bitnami/charts/tree/master/bitnami/mongodb) chart.
By default, the MongoDB chart requires PV support on underlying infrastructure (may be disabled).

## Installing the Chart

To install the chart with the release name `rocketchat`:

```console
helm upgrade --install rocketchat . \
  --set rocketchat.mongodb.auth.passwords={rocketchatPassword} \
  --set rocketchat.mongodb.auth.rootPassword=rocketchatRootPassword \
  --set route.host=myrocketchat.[rahtiapp.fi,apps.lumi-k.eu]
```

Usage of `values.yaml` file is recommended over using command line arguments `--set`. You must set at least the database password and root password in the values file.

```yaml
mongodb:
[...]
  auth:
    rootPassword: rocketchatroot
    passwords:
      - rocketchat
```
Regarding the OpenShift route, you must provide the `route.host`. For the domain, it can be either `apps.lumi-k.eu` if deployed on Lumi-K or `rahtiapp.fi` if deployed on Rahti.  

```yaml
route:
  host: "" # Edit this value to set the route host, e.g. "my-rocketchat.rahtiapp.fi"
```
Now use the following command to deploy

```console
helm install rocketchat . -f values.yaml
```

> Starting chart version 5.4.3, due to mongodb dependency, username, password and database entries must be arrays of the same length. Rocket.Chat will use the first entries of those arrays for its own use. `rocketchat.mongodb.auth.usernames` array defaults to `{rocketchat}` and `rocketchat.mongodb.auth.databases` array defaults to `{rocketchat}`

## Uninstalling the Chart

To uninstall the `rocketchat` deployment:

```console
helm uninstall rocketchat
```

### Database Setup

Rocket.Chat uses a MongoDB instance to presist its data.
By default, the [MongoDB chart](https://artifacthub.io/packages/helm/bitnami/mongodb?modal=values&compare-to=13.18.5) version 13.18.5 is deployed and a single MongoDB instance is created as the primary in a replicaset.  
Please refer to the (MongoDB) chart for additional MongoDB configuration options.
If you are using chart defaults, make sure to set at least the `rocketchat.mongodb.auth.rootPassword` and `rocketchat.mongodb.auth.passwords` values. 
> **WARNING**: The root credentials are used to connect to the MongoDB OpLog

#### Using an External Database

This chart supports using an existing MongoDB instance. Use the `` configuration options and disable MongoDB with `--set rocketchat.ongodb.enabled=false`

### Configuring Additional Environment Variables

```yaml
extraEnv: |
  - name: MONGO_OPTIONS
    value: '{"ssl": "true"}'
```
### Specifying aditional volumes

Sometimes, it's needed to include extra sets of files by means of exposing 
them to the container as a mountpoint. The most common use case is the 
inclusion of SSL CA certificates. 

```yaml
extraVolumes: 
  - name: etc-certs
    hostPath:
    - path: /etc/ssl/certs
      type: Directory
extraVolumeMounts: 
  - mountPath: /etc/ssl/certs
    name: etc-certs   
    readOnly: true
```

### Increasing Server Capacity and HA Setup

To increase the capacity of the server, you can scale up the number of Rocket.Chat server instances across available computing resources in your cluster, for example,

```bash
$ oc scale --replicas=3 deployment/rocketchat
```

By default, this chart creates one MongoDB instance as a Primary in a replicaset.  This is the minimum requirement to run Rocket.Chat 1.x+.    You can also scale up the capacity and availability of the MongoDB cluster independently.  Please see the [MongoDB chart](https://artifacthub.io/packages/helm/bitnami/mongodb?modal=values&compare-to=13.18.5) for configuration information.

For information on running Rocket.Chat in scaled configurations, see the [documentation](https://rocket.chat/docs/installation/docker-containers/high-availability-install/#guide-to-install-rocketchat-as-ha-with-mongodb-replicaset-as-backend) for more details.

### Manage MongoDB secrets

This chart provides several ways to manage the Connection for MongoDB
* Values passed to the chart (externalMongodbUrl, externalMongodbOplogUrl)
* An ExistingMongodbSecret containing the MongoURL and MongoOplogURL
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  mongo-uri: mongodb://user:password@localhost:27017/rocketchat
  mongo-oplog-uri: mongodb://user:password@localhost:27017/local?replicaSet=rs0&authSource=admin
```
