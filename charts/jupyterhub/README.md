# JupyterHub Helm Rahti 2
## TL;DR
```sh
helm upgrade --install jupyterhub .
```

## Explanations
This Helm Chart helps you to deploy JupyterHub on CSC Rahti (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install jupyterhub . -f {custom_values.yaml}
```

## Parameters
We created a default `values.yaml` file that is compatible with our platform Rahti. This Helm Chart is using the bitnami Helm Charts. Have a look:
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

We don't recommend this for a production environment. Pukki has database backups and is more robust. More information [here](https://docs.csc.fi/cloud/dbaas/)

Your hostname can be set by editing the values `route.host`. If omitted, the hostname will be generated randomly

```yaml
route:
  enabled: true
  host: my-jupyterhub.rahtiapp.fi # <-- Edit this value
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

You can implement different `authenticator_class`. Have a look:
- [Identity provider specific setup](https://oauthenticator.readthedocs.io/en/latest/tutorials/provider-specific-setup/index.html)
- [Configuring authenticator classes](https://z2jh.jupyter.org/en/stable/administrator/authentication.html#configuring-authenticator-classes)
- [OAuthenticators API reference](https://oauthenticator.readthedocs.io/en/latest/reference/api/index.html)

Follow the instructions from the NOTES.txt once the application is deployed.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall jupyterhub
```
