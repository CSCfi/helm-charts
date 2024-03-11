# Matomo Helm Chart
## TL;DR
```sh
helm upgrade --install matomo .
```

## Explanations
This Helm Chart helps you to deploy Matomo on CSC Rahti 2 (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install matomo . -f {custom_values.yaml}
```

## Parameters
### Mariadb parameters

| Name                                         | Description                                                  | Value                                                           |
| -------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------- |
| `mariadb.image`                              | Name of the `mariadb` image. We use the image in `openshift` | `image-registry.apps.2.rahti.csc.fi/openshift/mariadb:10.3-el8` |
| `mariadb.imageStream.name`                   | Name of the `ImageStream`                                    | `mariadb`                                                       |
| `mariadb.imageStream.tag`                    | Tag for the `ImageStream`                                    | `10.3-el8`                                                      |
| `mariadb.imageStream.namespace`              | Namespace for the `ImageStream`                              | `openshift`                                                     |
| `mariadb.name`                               | Name of your app.                                            | `mariadb`                                                       |
| `mariadb.service.type`                       | Set the Service type                                         | `ClusterIP`                                                     |
| `mariadb.pvc.storageSize`                    | Storage size for the PersistentVolume                        | `5Gi`                                                           |
| `mariadb.pvc.storageClassName`               | Storage Class Name for the PersistentVolume                  | `standard-csi`                                                  |
| `mariadb.random_pw_secret_key`               | Key to store the password                                    | `database-password`                                             |
| `mariadb.random_root_pw_secret_key`          | Key to store the root password                               | `database-root-password`                                        |
| `mariadb.secret.database-name`               | Name of the database                                         | `matomodb`                                                      |
| `mariadb.secret.database-user`               | Name of the database user                                    | `matomouser`                                                    |
| `mariadb.secret.database-password`           | Function that retrieve the generated password                | `'{{- include "random_mariadb_pw_reusable" . -}}'`              |
| `mariadb.secret.database-password`           | Function that retrieve the generated root password           | `'{{- include "random_mariadb_root_pw_reusable" . -}}'`         |
| `mariadb.livenessProbe.enabled`              | Enable or not `livenessProbe`                                | `true`                                                          |
| `mariadb.livenessProbe.initialDelaySeconds`  | Set the `livenessProbe.initialDelaySeconds`                  | `30`                                                            |
| `mariadb.livenessProbe.timeoutSeconds`       | Set the `livenessProbe.timeoutSeconds`                       | `1`                                                             |
| `mariadb.readinessProbe.enabled`             | Enable or not `readinessProbe`                               | `true`                                                          |
| `mariadb.readinessProbe.initialDelaySeconds` | Set the `readinessProbe.initialDelaySeconds`                 | `5`                                                             |
| `mariadb.readinessProbe.timeoutSeconds`      | Set the `readinessProbe.timeoutSeconds`                      | `1`                                                             |
| `mariadb.resources.limits.memory`            | Set the memory limits                                        | `512Mi`                                                         |
 
### Matomo parameters

| Name                                             | Description                                                          | Value                                             |
| ------------------------------------------------ | -------------------------------------------------------------------- | ------------------------------------------------- |
| `matomo.image`                                   | Name of the `matomo` image.                                          | `bitnami/matomo:latest`                           |
| `matomo.name`                                    | Name of your app.                                                    | `matomo`                                          |
| `matomo.service.type`                            | Set the Service type                                                 | `ClusterIP`                                       |
| `matomo.route.tls.insecureEdgeTerminationPolicy` | Set the termination policy regarding insecure traffic for the route  | `Redirect`                                        |
| `matomo.route.tls.termination`                   | Set the termination for the route                                    | `edge`                                            |
| `matomo.random_pw_secret_key`                    | Key to store the password                                            | `matomo-password`                                 |
| `matomo.secret.matomo-username`                  | Name of the matomo user                                              | `matomouser`                                      |
| `matomo.secret.matomo-password`                  | Function that retrieve the generated password                        | `'{{- include "random_matomo_pw_reusable" . -}}'` |

The password for the mariadb database and the root password are generated randomly. A function is created in the `_helpers.tpl` file.  
It's the same behavior for the matomo user password.

The passwords won't change if you upgrade the Chart.

Follow the instructions after deploying the Helm Chart to retrieve the passwords.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall matomo
```