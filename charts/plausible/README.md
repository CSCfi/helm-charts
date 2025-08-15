# Plausible Analytics Helm Chart

> [!IMPORTANT]  
> Bitnami is changing its policy regarding their catalog starting August 28th 2025. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images will be moved to [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) with no more updates.  
> - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue to receive images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> Some of our Helm Charts used `bitnami` images. By default, they are now meant for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
> However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. It is possible to build the image and then push it to your CSC project. More information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)

## TL;DR
```sh
helm upgrade --install plausible .
```

## Explanations
This Helm Chart helps you to deploy Plausible on CSC Rahti (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
cd charts/plausible
helm upgrade --install plausible . -f {custom_values.yaml}
```

## Parameters
We created a default `values.yaml` file that is compatible with our platform Rahti. This Helm Chart is using the bitnami Helm Charts for postgresql and clickhouse and also the Helm Chart from IMIO for plausible-community. Take a look:
- [bitnami/postgresql](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
- [bitnami/clickhouse](https://github.com/bitnami/charts/tree/main/bitnami/clickhouse)
- [imio/plausible-analytics](https://github.com/IMIO/helm-plausible-analytics/tree/main)

By default, the deployment of PostgreSQL alongside Plausible analitycs is disabled.

We strongly recommend to create a database in our DBaaS service called [Pukki](https://pukki.dbaas.csc.fi/). Be sure to allow Rahti egress IP `86.50.229.150/32` to allow your pod to connect to Pukki.

One more thing. You need to grant creation privileges. Once the Pukki database is created, connect using the [root credentials](https://docs.csc.fi/cloud/dbaas/operations/#enable-root) and run this command:

```sh
GRANT CREATE ON DATABASE your_database_name TO your_database_username;
```

If you decide to deploy PostgreSQL on Rahti, please change the value `postgresql.enabled` from `false` to `true`

Some mandatory values:

- `plausible.baseURL`: this values must be the same as `plausible.ingress.hosts` beginning with `https`

- `plausible.databaseURL`: your postgreSQL database address. Must be like `postgres://<username>:<password>@<hostname_or_public_IP>:<port>/<database>`

- `plausible.clickhouseDatabaseURL`: the URL Connection String to clickhouse DB. Must be like `http://<username>:<password>@plausible-clickhouse.<your_csc_project_name>.svc.cluster.local:8123/plausible_events_db`

- `clickhouse.auth.username` and `clickhouse.auth.password`: Define your username and password for the clickhouse database.

### IP whitelisting

You can whitelist IP where only a few ranges are allowed to get through the route. More information here: https://docs.csc.fi/cloud/rahti/concepts/#ip-white-listing

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall plausible
```