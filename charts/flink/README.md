# Flink Helm Chart

> [!IMPORTANT]  
> Starting on 29 September 2025, Bitnami will be changing its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images will be moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - Some of our Helm Charts used `Bitnami` images. Our Helm Charts are now intended for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)

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
