# Plausible Analytics Helm Chart
## TL;DR
```sh
helm upgrade --install plausible .
```

## Explanations
This Helm Chart helps you to deploy Plausible on CSC Rahti (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install matomo . -f {custom_values.yaml}
```

## Parameters
We created a default `values.yaml` file that is compatible with our platform Rahti. This Helm Chart is using the bitnami Helm Charts for postgresql and clickhouse and also the Helm Chart from IMIO for plausible-community. Take a look:
- [bitnami/postgresql](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
- [bitnami/clickhouse](https://github.com/bitnami/charts/tree/main/bitnami/clickhouse)
- [imio/plausible-analytics](https://github.com/IMIO/helm-plausible-analytics/tree/main)

By default, the deployment of PostgreSQL alongside Plausible analitycs is disable.
We strongly recommend to create a database in our DBaaS service called [Pukki](https://pukki.dbaas.csc.fi/)

If you decide to deploy PostgreSQL on Rahti, please change the value `postgresql.enabled` from `false` to `true`

Some mandatory values:

- `plausible.baseURL`: this values must be the same as `plausible.ingress.hosts` beginning with `https`

- `plausible.databaseURL`: your postgreSQL database address. Must be like `postgres://<username>:<password>@<hostname_or_public_IP>:<port>/<database>`

- `plausible.clickhouseDatabaseURL`: the URL Connection String to clickhouse DB. Must be like `http://<username>:<password>@plausible-clickhouse.<your_csc_project_name>.svc.cluster.local:8123/plausible_events_db`

- `clickhouse.auth.username` and `clickhouse.auth.password`: Define your username and password for the clickhouse database.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall plausible
```