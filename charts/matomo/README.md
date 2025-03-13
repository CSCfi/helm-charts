# Matomo Helm Chart
## TL;DR
```sh
helm upgrade --install matomo .
```

## Explanations
This Helm Chart helps you to deploy Matomo on CSC Rahti (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install matomo . -f {custom_values.yaml}
```

## Parameters
We created a default `values.yaml` file that is compatible with our platform Rahti. This Helm Chart is using the bitnami Helm Charts. Take a look:
- [bitnami/mariadb](https://github.com/bitnami/charts/tree/main/bitnami/mariadb)
- [bitnami/matomo](https://github.com/bitnami/charts/tree/main/bitnami/matomo)

By default, it will deploy a MariaDB database alongside Matomo. The credentials are generated automatically.

Follow the instructions from the NOTES.txt to retrieve the information, once the application is deployed.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall matomo
```