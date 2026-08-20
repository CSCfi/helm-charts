# Flink Helm Chart

> [!IMPORTANT]  
> Since on 29 September 2025, Bitnami has changed its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images have been moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images are available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)  
> - Some of our Helm Charts use `Bitnami` images. We migrated most of the important images to the CSC Container Registry [Satama](https://satama.csc.fi).  
> - Be mindful when deploying these charts in your production environment.  

## Getting started

[Helm](helm.sh) and `oc` CLI must be installed on your local machine.

## Introduction

This Helm Chart helps you to deploy Flink on CSC Rahti or Lumi-K (Openshift 4).

It is highly recommended to use the Helm CLI instead of the WebUI of Rahti. If so, you can clone the GitHub repository from [here](https://github.com/CSCfi/helm-charts).  
Helm CLI allows you to download the necessary dependencies in order to run the chart.

Once set, run:

```sh
helm upgrade --install flink . -f values.yaml
```


## Cleanup

To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall flink
```
