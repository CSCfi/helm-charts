# Spark Helm Chart

> [!IMPORTANT]  
> Starting on 29 September 2025, Bitnami will be changing its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images will be moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - Some of our Helm Charts used `Bitnami` images. Our Helm Charts are now intended for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)

## Explanations

This Helm Chart helps you to deploy Spark on CSC Rahti or Lumi-K (Openshift 4).

We created a default `values.yaml` file that is compatible with our platforms Rahti and Lumi-K. This Helm Chart is using the bitnami Helm Charts. Take a look:
- [bitnami/spark](https://github.com/bitnami/charts/blob/main/bitnami/spark/)

By default, it will use an Ingress instead of the Route Openshift API. Don't forget to set up your host:

```yaml
spark:
  ingress:
    enabled: true
    hostname: myspark.rahtiapp.fi # or myspark.apps.lumi-k.eu
```

You can use the Spark Master as [reverse proxy](https://github.com/bitnami/charts/blob/main/bitnami/spark/README.md#configuring-spark-master-as-reverse-proxy).

Coupled with `ingress` configuration, you can set `spark.master.configOptions` and `spark.worker.configOptions` to tell Spark to reverse proxy the worker
and applications UIs to enable access without requiring direct access to their hosts:

```yaml
spark:
  master:
    configOptions:
      -Dspark.ui.reverseProxy=true
      -Dspark.ui.reverseProxyUrl=https://myspark.[rahtiapp.fi,apps.lumi-k.eu]
  worker:
    configOptions:
      -Dspark.ui.reverseProxy=true
      -Dspark.ui.reverseProxyUrl=https://myspark.[rahtiapp.fi,apps.lumi-k.eu]
  ingress:
    enabled: true
    hostname: myspark.[rahtiapp.fi,apps.lumi-k.eu]
```

Once set, run:

```sh
helm upgrade --install spark . -f values.yaml
```

Follow the instructions from the NOTES.txt once the application is deployed.

## Cleanup

To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall spark
```