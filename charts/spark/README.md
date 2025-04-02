# Spark Helm Chart
## TL;DR
```sh
helm upgrade --install spark .
```

## Explanations
This Helm Chart helps you to deploy Spark on CSC Rahti (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install spark . -f {custom_values.yaml}
```

## Parameters
We created a default `values.yaml` file that is compatible with our platform Rahti. This Helm Chart is using the bitnami Helm Charts. Take a look:
- [bitnami/spark](https://github.com/bitnami/charts/blob/main/bitnami/spark/)

By default, it will use an Ingress instead of the Route Openshift API. Don't forget to set up your host:

```yaml
spark:
  ingress:
    enabled: true
    hostname: myspark.rahtiapp.fi
```

You can use the Spark Master as [reverse proxy](https://github.com/bitnami/charts/blob/main/bitnami/spark/README.md#configuring-spark-master-as-reverse-proxy).

Coupled with `ingress` configuration, you can set `spark.master.configOptions` and `spark.worker.configOptions` to tell Spark to reverse proxy the worker
and applications UIs to enable access without requiring direct access to their hosts:

```yaml
spark:
  master:
    configOptions:
      -Dspark.ui.reverseProxy=true
      -Dspark.ui.reverseProxyUrl=https://myspark.rahtiapp.fi
  worker:
    configOptions:
      -Dspark.ui.reverseProxy=true
      -Dspark.ui.reverseProxyUrl=https://myspark.rahtiapp.fi
  ingress:
    enabled: true
    hostname: myspark.rahtiapp.fi
```

Follow the instructions from the NOTES.txt once the application is deployed.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall spark
```