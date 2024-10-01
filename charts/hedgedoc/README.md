# HedgeDoc Helm Chart
## TL;DR
```sh
helm upgrade --install hedgedoc .
```
## Getting started
[Helm](helm.sh) and `oc` CLI must be installed on your local machine.

## Introduction
This Helm Chart helps you to deploy HedgeDoc on CSC Rahti (Openshift 4).

It is highly recommended to use the Helm CLI instead of the WebUI of Rahti2. If so, you can clone the GitHub repository from [here](https://github.com/CSCfi/helm-charts).  
Helm CLI allows you:
- to download the necessary dependencies in order to run the chart, if you decide to run PostgreSQL in Rahti2.
- to set the necessary values (see command below), if you decide to run a PostgreSQL instance externally.

If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install hedgedoc . -f {custom_values.yaml}
```

By default, this Helm Chart won't deploy a postgreSQL database along Hedgedoc. If you want to connect Hedgedoc to an existing external database, you have to enable the parameters
`postgresql.enabled` and disable the default one `postgresqlExternal.enabled`. More information below in the table.

## Parameters
### Common parameters

| Name                                   | Description                                             | Value      |
| -------------------------------------- | ------------------------------------------------------- | ---------- |
| `openshift.enabled`                    | If you are deploying on OKD 4                           | `true`     |
| `route.insecureEdgeTerminationPolicy`  | If `openshift.enabled`, will create a route             | `Redirect` |
| `route.termination`                    | If `openshift.enabled`, will create a route             | `edge`     |

### HedgeDoc parameters

| Name                                   | Description                                             | Value                                      |
| -------------------------------------- | ------------------------------------------------------- | ------------------------------------------ |
| `hedgedoc.appname`                     | Name of your app. Used for the creation of the `route`  | `my-hedgedoc`                              |
| `hedgedoc.domain`                      | Name of your domain where the Helm is deployed          | `rahtiapp.fi`                              |
| `hedgedoc.image`                       | Name of the `hedgedoc` image                            | `quay.io/hedgedoc/hedgedoc:1.9.4`          |
| `hedgedoc.podSecurityContext`          | Set SecurityContext for the pod                         | `{}`                                       |
| `hedgedoc.containerSecurityContext`    | Set SecurityContext for the container                   | `allowPrivilegeEscalation: false`<br>`runAsUser:`<br>`runAsGroup:`<br>`capabilities:`<br>&nbsp;&nbsp;`drop:`<br>&nbsp;&nbsp;`- ALL`<br>`runAsNonRoot: true`<br>`seccompProfile:`<br>&nbsp;&nbsp;`type: RuntimeDefault` |
| `hedgedoc.pvc.storageSpace`            | Storage space for the PersistentVolume                  | `5Gi`                                      |
| `hedgedoc.random_pw_secret_key`        | Key to store the password                               | `database-password`                        |
| `hedgedoc.secret.databaseName`         | Name of the database. Linked to `postgresql.auth.database`. EDIT `postgresql.auth.database` instead of this value!                                    | `{{ tpl .Values.postgresql.auth.database . }}` |
| `hedgedoc.secret.databaseUser`         | Name of the postgres user. Linked to `postgresql.auth.username`. EDIT `postgresql.auth.username` instead of this value!                              | `{{ tpl .Values.postgresql.auth.database . }}` |
| `hedgedoc.secret.databasePassword`     | Empty by default because the password is generated randomly and stored in a Secret. Replace this value if you want to add your custom password. | `''` |
| `hedgedoc.secret.password`     | Empty by default because the password is generated randomly and stored in a Secret. Replace this value if you want to add your custom password. | `''` |
| `hedgedoc.secret.postgresPassword`     | Empty by default because the password is generated randomly and stored in a Secret. Replace this value if you want to add your custom password. | `''` |

### PostgreSQL parameters

Since we are using the `bitnami/postgresql` Helm Chart as a dependency, you can take a look to the [PostgreSQL ArtifactHub](https://artifacthub.io/packages/helm/bitnami/postgresql/15.5.0) to check the different values.

This parameters is disabled by default. If you want to use a postgresql database among, enable it with `postgresql.enabled`


### HedgeDoc parameters

By default it will use an external database. Here are the parameters:

| Name                                          | Description                                                          | Value      |
| --------------------------------------------- | -------------------------------------------------------------------- | -----------|
| `postgresqlExternal.enabled`                  | If you want to use an existing external database                     | `true`     |
| `postgresqlExternal.externalDatabase`         | If you are using Pukki, enter its DNS name or public address IP      | `0.0.0.0`  |
| `postgresqlExternal.secret.database-name`     | If you are using Pukki, enter the database created                   | `hedgedoc` |
| `postgresqlExternal.secret.database-username` | If you are using Pukki, enter the username created                   | `hedgedoc` |
| `postgresqlExternal.secret.database-password` | If you are using Pukki, enter the passworc created                   | `hedgedoc` |

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall hedgedoc
```
