# Helm charts repository for Rahti

> [!IMPORTANT]  
> Bitnami is changing its policy regarding their catalog starting August 28th 2025. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images will be moved to [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) with no more updates.  
> - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue to receive images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> Some of our Helm Charts used `bitnami` images. By default, they are now meant for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
> However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. It is possible to build the image and then push it to your CSC project. More information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)

Add this Helm Chart repository by running this command:

```bash
helm repo add csc https://cscfi.github.io/helm-charts/
```