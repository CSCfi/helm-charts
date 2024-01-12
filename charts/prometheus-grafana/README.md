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

## Parameters

### HedgeDoc parameters

| Name                                                 | Description                                             | Value                             |
| ---------------------------------------------------- | ------------------------------------------------------- | --------------------------------- |
| `prometheus.appName`                                 | Name of your app.                                       | `prometheus`                      |
| `prometheus.image`                                   | Name of the `prometheus` image                          | `prom/prometheus:v2.45.2`         |
| `prometheus.retentionTime`                           | Define how long data is kept in time-series database    | `15d`                             |
| `prometheus.limits.memory`                           | Define the maximum of amount of memory                  | `4Gi`                             |
| `prometheus.requests.memory`                         | Define the minimum guaranteed amount of memory          | `4Gi`                             |
| `prometheus.secret.user`                             | Name of the user to connect to prometheus webUI         | `admin`                           |
| `prometheus.pvc.storageSize`                         | Define the size of the Persistent Volume Claim          | `5Gi`                             |
| `prometheus.service.type`                            | Define the service type                                 | `ClusterIP`                       |
| `prometheus.route.tls.termination`                   | Create an OpenShift route                               | `edge`                            |
| `prometheus.route.tls.insecureEdgeTerminationPolicy` | Create an OpenShift route                               | `Redirect`                        |

### Grafana parameters

| Name                                                 | Description                                             | Value                             |
| ---------------------------------------------------- | ------------------------------------------------------- | --------------------------------- |
| `grafana.appName`                                    | Name of your app.                                       | `grafana`                         |
| `grafana.image`                                      | Name of the `prometheus` image                          | `grafana/grafana:9.5.15`          |
| `grafana.limits.memory`                              | Define the maximum of amount of memory                  | `1Gi`                             |
| `grafana.requests.memory`                            | Define the minimum guaranteed amount of memory          | `1Gi`                             |
| `grafana.secret.adminUsername`                       | Name of the user to connect to prometheus webUI         | `admin`                           |
| `grafana.pvc.storageSize`                            | Define the size of the Persistent Volume Claim          | `5Gi`                             |
| `grafana.service.type`                               | Define the service type                                 | `ClusterIP`                       |
| `grafana.route.tls.termination`                      | Create an OpenShift route                               | `edge`                            |
| `grafana.route.tls.insecureEdgeTerminationPolicy`    | Create an OpenShift route                               | `Redirect`                        |

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall graf-prom
```