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
| `hedgedoc.random_pw_secret_key`        | Key to store the password                               | `database-password`               |
| `hedgedoc.secret.database-name`        | Name of the database                                    | `postgres`                        |
| `hedgedoc.secret.database-user`        | Name of the postgres user                               | `postgres`                        |
| `hedgedoc.secret.database-password`    | Function that retrieve the generated password           | `'{{- include "random_pw_reusable" . -}}'` |

### PostgreSQL parameters

Since we are using the `bitnami/postgresql` Helm Chart as a dependency, you can take a look to the [PostgreSQL ArtifactHub](https://artifacthub.io/packages/helm/bitnami/postgresql/13.4.4) to check the different values.

The postgres database password is generated randomly and won't change if you upgrade the Chart.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall hedgedoc
```