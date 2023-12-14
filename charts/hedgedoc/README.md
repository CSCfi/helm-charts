# HedgeDoc Helm Chart
## TL;DR
```sh
helm upgrade --install hedgedoc .
```

## Explanations
This Helm Chart helps you to deploy HedgeDoc on CSC Rahti (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install hedgedoc . -f {custom_values.yaml}
```

## Parameters
### Common parameters

| Name                                   | Description                                             | Value      |
| -------------------------------------- | ------------------------------------------------------- | ---------- |
| `openshift.enabled`                    | If you are deploying on OKD 4                           | `true`     |
| `secret.name`                          | Name for the secret                                     | `postgres` |
| `secret.databaseName`                  | Set the name for the HedgeDoc database                  | `hedgedoc` |
| `secret.databaseUser`                  | Set the user for the HedgeDoc database                  | `hedgedoc` |
| `route.insecureEdgeTerminationPolicy`  | If `openshift.enabled`, will create a route             | `Redirect` |
| `route.termination`                    | If `openshift.enabled`, will create a route             | `edge`     |

### HedgeDoc parameters

| Name                                   | Description                                             | Value                             |
| -------------------------------------- | ------------------------------------------------------- | --------------------------------- |
| `hedgedoc.appname`                     | Name of your app. Used for the creation of the `route`  | `my-hedgedoc`                     |
| `hedgedoc.domain`                      | Name of your domain where the Helm is deployed          | `rahtiapp.fi`                     |
| `hedgedoc.image`                       | Name of the `hedgedoc` image                            | `quay.io/hedgedoc/hedgedoc:1.9.4` |
| `hedgedoc.podSecurityContext`          | Set SecurityContext for the pod                         | `{}`                              |
| `hedgedoc.containerSecurityContext`    | Set SecurityContext for the container                   | `allowPrivilegeEscalation: false`<br>`runAsUser:`<br>`runAsGroup:`<br>`capabilities:`<br>&nbsp;&nbsp;`drop:`<br>&nbsp;&nbsp;`- ALL`<br>`runAsNonRoot: true`<br>`seccompProfile:`<br>&nbsp;&nbsp;`type: RuntimeDefault` |
| `hedgedoc.pvc.storageSpace`            | Storage space for the PersistentVolume                  | `5Gi`                             |
| `hedgedoc.service.type`                | Set the Service type                                    | `ClusterIP`                       |

### PostgreSQL parameters

| Name                                          | Description                                             | Value                                                            |
| --------------------------------------------- | ------------------------------------------------------- | ---------------------------------------------------------------- |
| `postgres.image  `                            | Name of the `postgresql` image                          | `image-registry.apps.2.rahti.csc.fi/openshift/postgresql:12-el8` |
| `postgres.livenessProbe.enabled`              | Enable or not `livenessProbe`                           | `true`                                                           |
| `postgres.livenessProbe.failureThreshold`     | Set the `livenessProbe.failureThreshold`                | `3`                                                              |
| `postgres.livenessProbe.initialDelaySeconds`  | Set the `livenessProbe.initialDelaySeconds`             | `120`                                                            |
| `postgres.livenessProbe.periodSeconds`        | Set the `livenessProbe.periodSeconds`                   | `10`                                                             |
| `postgres.livenessProbe.successThreshold`     | Set the `livenessProbe.successThreshold`                | `1`                                                              |
| `postgres.livenessProbe.timeoutSeconds`       | Set the `livenessProbe.timeoutSeconds`                  | `10`                                                             |
| `postgres.readinessProbe.enabled`             | Enable or not `readinessProbe`                          | `true`                                                           |
| `postgres.readinessProbe.failureThreshold`    | Set the `readinessProbe.failureThreshold`               | `3`                                                              |
| `postgres.readinessProbe.initialDelaySeconds` | Set the `readinessProbe.initialDelaySeconds`            | `5`                                                              |
| `postgres.readinessProbe.periodSeconds`       | Set the `readinessProbe.periodSeconds`                  | `10`                                                             |
| `postgres.readinessProbe.successThreshold`    | Set the `readinessProbe.successThreshold`               | `1`                                                              |
| `postgres.readinessProbe.timeoutSeconds`      | Set the `readinessProbe.timeoutSeconds`                 | `10`                                                             |
| `postgres.resources.limits.memory`            | Set the resources limits memory                         | `512Mi`                                                          |
| `postgres.podSecurityContext`                 | Set SecurityContext for the pod                         | `{}`                                                             |
| `postgres.containerSecurityContext`           | Set SecurityContext for the container                   | `allowPrivilegeEscalation: false`<br>`runAsUser:`<br>`runAsGroup:`<br>`capabilities:`<br>&nbsp;&nbsp;`drop:`<br>&nbsp;&nbsp;`- ALL`<br>`runAsNonRoot: true`<br>`seccompProfile:`<br>&nbsp;&nbsp;`type: RuntimeDefault` |
| `postgres.pvc.storageSpace`                   | Storage space for the PersistentVolume                  | `5Gi`                                                            |
| `postgres.service.type`                       | Set the Service type                                    | `ClusterIP`                                                      |

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall hedgedoc
```