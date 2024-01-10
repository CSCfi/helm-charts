# Minio Helm Chart
## TL;DR
```sh
helm upgrade --install minio .
```

## Explanations
This Helm Chart helps you to deploy Minio on CSC Rahti 2 (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install minio . -f {custom_values.yaml}
```

## Parameters
### minio parameters

| Name                                            | Description                                                          | Value                                      |
| ----------------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------|
| `minio.domainSuffix`                            | Set the `domainSuffix` for your minio app                            | `2.rahtiapp.fi`                            |
| `minio.whiteList`                               | Set the access of your minio app                                     | `0.0.0.0/0`                                |
| `minio.clusterName`                             | Name for your minio cluster                                          | `my-minio-cluster`                         |
| `minio.image`                                   | Name of the Minio image                                              | `minio/minio:RELEASE.2023-12-14T18-51-57Z` |
| `minio.resources.limits.cpu`                    | Set the limits cpu                                                   | `500m`                                     |
| `minio.resources.limits.memory`                 | Set the limits memory                                                | `512Mi`                                    |
| `minio.resources.requests.cpu`                  | Set the requests memory                                              | `200m`                                     |
| `minio.resources.requests.memory`               | Set the requests memory                                              | `256Mi`                                    |
| `minio.readinessProbe.enabled`                  | Enable or not the `readinessProbe`                                   | `true`                                     |
| `minio.readinessProbe.httpGet.path`             | Set the `httpGet` path for the `readinessProbe`                      | `/minio/health/ready`                      |
| `minio.readinessProbe.httpGet.port`             | Set the `httpGet` port for the `readinessProbe`                      | `9000`                                     |
| `minio.readinessProbe.httpGet.scheme`           | Set the `httpGet` scheme for the `readinessProbe`                    | `HTTP`                                     |
| `minio.pvc.name`                                | Name for the PersistentVolumeClaim                                   | `minio-pvc`                                |
| `minio.pvc.storageSize`                         | Storage size for the PersistentVolumeClaim                           | `5Gi`                                      |
| `minio.pvc.storageClassName`                    | Storage Class Name for the PersistentVolumeClaim                     | `standard-csi`                             |
| `minio.service.type`                            | Set the Service type                                                 | `ClusterIP`                                |
| `minio.route.tls.termination`                   | Set the termination for the route                                    | `edge`                                     |
| `minio.route.tls.insecureEdgeTerminationPolicy` | Set the termination policy regarding insecure traffic for the route  | `Redirect`                                 |

The secretKey and the accessKey for the minio console are generated randomly. A function is created in the `_helpers.tpl` file.  

Follow the instructions after deploying the Helm Chart to retrieve the passwords.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall minio
```