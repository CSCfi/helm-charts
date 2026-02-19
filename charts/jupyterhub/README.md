# JupyterHub Helm Chart

> [!IMPORTANT]  
> Starting on 29 September 2025, Bitnami will be changing its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images will be moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - Some of our Helm Charts used `Bitnami` images. Our Helm Charts are now intended for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)

## Explanations

This Helm Chart helps you to deploy JupyterHub on CSC Rahti/Lumi-K (Openshift 4).

## Parameters

We created a default `values.yaml` file that is compatible with our platform Rahti/Lumi-K. This Helm Chart is using the bitnami Helm Charts. Have a look:
- [bitnami/jupyterhub](https://github.com/bitnami/charts/blob/main/bitnami/jupyterhub/)

By default, you need to set up a PostgreSQL database on [Pukki](https://pukki.dbaas.csc.fi) and then edit the values in `values.yaml`:

```yaml
jupyterhub:
  externalDatabase:
    host: # Public IP Address of your Pukki database
    port: 5432
    user: # Username
    database: # Database name
    password: # Database password
    existingSecret: ""
    existingSecretPasswordKey: ""
```

If you want, you can set up a PostgreSQL database alongside your jupyterhub pods. Change the parameter from `false` to `true` in `jupyterhub.postgresql.enabled`.

```yaml
jupyterhub:
  postgresql:
    enabled: false # <-- Change this to true
    global:
      security:
        allowInsecureImages: true
    image:
      registry: ""
      repository: ""
      tag: ""
    auth:
      username: bn_jupyterhub
      password: ""
      database: bitnami_jupyterhub
      existingSecret: ""
  architecture: standalone
  service:
    ports:
      postgresql: 5432
```

You need to provide your own image if you want to use `postgresql` on Rahti or Lumi-K. Since the Bitnami policy change, they provide images but with old tags. For example [postgresql](https://hub.docker.com/r/bitnamilegacy/postgresql).

We don't recommend this for a production environment. Pukki has database backups and is more robust. More information [here](https://docs.csc.fi/cloud/dbaas/)

Your hostname can be set by editing the values `route.host`. If omitted, the hostname will be generated randomly

```yaml
route:
  enabled: true
  host: "" # <-- Edit this value. For example, my-jupyterhub.rahtiapp.fi or my-jupyterhub.apps.lumi-k.eu
```

Same with `jupyterhub.proxy.hostname` if you decide to enable the Ingress.
This Helm Chart will deploy the [Native Authenticator](https://github.com/jupyterhub/nativeauthenticator) by default. You can set the admin user in `jupyterhub.hub.adminUser`.
You must sign up to set the password for the admin user.

```yaml
jupyterhub:
  hub:
    configuration: |
      ...
      hub:
        config:
          JupyterHub:
            admin_access: true
            authenticator_class: nativeauthenticator.NativeAuthenticator
            Authenticator:
              admin_users:
                - {{ .Values.hub.adminUser }}
      ...
```

Any user can sign up but the admin must authorize them to log in. Use this url: `http://<your-notebook>.rahtiapp.fi/hub/authorize`

You can implement different `authenticator_class`. Take a look:
- [Identity provider specific setup](https://oauthenticator.readthedocs.io/en/latest/tutorials/provider-specific-setup/index.html)
- [Configuring authenticator classes](https://z2jh.jupyter.org/en/stable/administrator/authentication.html#configuring-authenticator-classes)
- [OAuthenticators API reference](https://oauthenticator.readthedocs.io/en/latest/reference/api/index.html)

Once set, run:

```sh
helm upgrade --install jupyterhub . -f values.yaml
```

Follow the instructions from the NOTES.txt once the application is deployed.

## Cleanup

To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall jupyterhub
```
