# Matomo Helm Chart

> [!IMPORTANT]  
> Starting on 29 September 2025, Bitnami will be changing its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images will be moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - Some of our Helm Charts used `Bitnami` images. Our Helm Charts are now intended for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)

## Explanations

This Helm Chart helps you to deploy Matomo on CSC Rahti or Lumi-K (Openshift 4).

## Parameters

We created a default `values.yaml` file that is compatible with our platform Rahti. This Helm Chart is using the bitnami Helm Charts. Take a look:
- [bitnami/mariadb](https://github.com/bitnami/charts/tree/main/bitnami/mariadb)
- [bitnami/matomo](https://github.com/bitnami/charts/tree/main/bitnami/matomo)

By default, it will deploy a MariaDB database alongside Matomo. The credentials are generated automatically.

Your hostname can be set by editing the values `route.host`. If omitted, the hostname will be generated randomly

```yaml
route:
  enabled: true
  host: "" # <-- Edit this value. For example, my-matomo.rahtiapp.fi or my-matomo.apps.lumi-k.eu
```

Once set, run:

```sh
helm upgrade --install matomo . -f values.yaml
```

Follow the instructions from the NOTES.txt to retrieve the information, once the application is deployed.

## Cleanup

To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall matomo
```
