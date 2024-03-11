# Grafana and Prometheus Helm Chart
## TL;DR
```sh
helm upgrade --install graf-prom .
```

## Explanations
This Helm Chart helps you to deploy Grafana and Prometheus on CSC Rahti2 (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install graf-prom . -f {custom_values.yaml}
```

The password to access Grafana WebUI is generated randomly and won't change if you upgrade your chart.

## Parameters

### HedgeDoc parameters

| Name                                                 | Description                                             | Value                             |
| ---------------------------------------------------- | ------------------------------------------------------- | --------------------------------- |
| `prometheus.appName`                                 | Name of your app.                                       | `prometheus`                      |
| `prometheus.image`                                   | Name of the `prometheus` image                          | `prom/prometheus:v2.50.1`         |
| `prometheus.retentionTime`                           | Define how long data is kept in time-series database    | `15d`                             |
| `prometheus.limits.memory`                           | Define the maximum of amount of memory                  | `4Gi`                             |
| `prometheus.requests.memory`                         | Define the minimum guaranteed amount of memory          | `4Gi`                             |
| `prometheus.pvc.storageSize`                         | Define the size of the Persistent Volume Claim          | `5Gi`                             |
| `prometheus.service.type`                            | Define the service type                                 | `ClusterIP`                       |

### Grafana parameters

| Name                                                 | Description                                             | Value                                      |
| ---------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------ |
| `grafana.appName`                                    | Name of your app.                                       | `grafana`                                  |
| `grafana.image`                                      | Name of the `prometheus` image                          | `grafana/grafana:10.2.4`                   |
| `grafana.limits.memory`                              | Define the maximum of amount of memory                  | `1Gi`                                      |
| `grafana.requests.memory`                            | Define the minimum guaranteed amount of memory          | `1Gi`                                      |
| `grafana.random_pw_secret_key`                       | Key to store the password                               | `admin-password`                           |
| `grafana.secret.admin-username`                      | Name of the user to connect to prometheus webUI         | `admin`                                    |
| `grafana.secret.admin-password`                      | Function that retrieve the generated password           | `'{{- include "random_pw_reusable" . - }}` |
| `grafana.service.type`                               | Define the service type                                 | `ClusterIP`                                |
| `grafana.route.tls.termination`                      | Create an OpenShift route                               | `edge`                                     |
| `grafana.route.tls.insecureEdgeTerminationPolicy`    | Create an OpenShift route                               | `Redirect`                                 |
| `grafana.pvc.storageSize`                            | Define the size of the Persistent Volume Claim          | `5Gi`                                      |

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall graf-prom
```