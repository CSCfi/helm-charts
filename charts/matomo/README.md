# Matomo Helm Chart

> [!IMPORTANT]  
> Since on 29 September 2025, Bitnami has changed its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images have been moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images are available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)  
> - Some of our Helm Charts use `Bitnami` images. We migrated most of the important images to the CSC Container Registry [Satama](https://satama.csc.fi).  
> - Be mindful when deploying these charts in your production environment.  

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
