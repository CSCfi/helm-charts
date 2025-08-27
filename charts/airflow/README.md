# Helm Chart for Apache Airflow

[Apache Airflow](https://airflow.apache.org/) is a platform to programmatically author, schedule and monitor workflows.

## Introduction

This chart will bootstrap an [Airflow](https://airflow.apache.org) deployment on a [OpenShift](http://okd.io)
cluster using the [Helm](https://helm.sh) package manager.

## Requirements

- Kubernetes 1.30+ cluster
- Helm 3.10+

## Deployment

### Webserver secret

As mentioned in the documentation, you must create a [Webserver Secret Key](https://airflow.apache.org/docs/helm-chart/stable/production-guide.html#webserver-secret-key). To do this, type this command:  

   ```sh
   oc create secret generic webserver-secret-key --from-literal="webserver-secret-key=$(python3 -c 'import secrets; print(secrets.token_hex(16))')"
   ```
Once the secret is created, you must define it in the chart in `.airflow.webserverSecretKey`

  ```yaml
  data:
    webserverSecretKey: webserver-secret-key
  ```

### PostgreSQL

It is advised to set up an [external database](https://airflow.apache.org/docs/helm-chart/stable/production-guide.html#database) for Airflow. You can use our service [Pukki](pukki.dbaas.csc.fi)

Once you created your database instance in Pukki, you can store the [credentials](https://airflow.apache.org/docs/helm-chart/stable/production-guide.html#kubernetes-secret) in a secret

  ```sh
  oc create secret generic mydatabase --from-literal=connection=postgresql://user:pass@host:5432/database
  ```

_**Replace user, pass, host and database**_

Then, define the secret in the chart in `.airflow.data.metadataSecretName`

  ```yaml
  data:
    metadataSecretName: mydatabase
  ```

### Default user

You can change the default user for the Webserver by modifying the values `airflow.webserver.defaultUser`

  ```yaml
  webserver:
    defaultUser:
      enabled: true
      role: Admin
      username: admin
      email: admin@example.com
      firstName: admin
      lastName: user
      password: admin
  ```

### Ingress and Route

By default, a Route will be deployed to access the web interface.

You can set Ingresses in the chart in `airflow.ingress`

  ```yaml
  ingress:
    apiServer:
      enabled: false
      hosts: []
      path: /
    web:
      enabled: false
      hosts: []
      path: /
    flower:
      enabled: false
      hosts: []
      path: /
    statsd:
      enabled: false
      hosts: []
      path: /metrics
    pgbouncer:
      enabled: false
      hosts: []
      path: /metrics
  ```

Once done, you can install the chart with Helm:

  ```sh
  helm install airflow .
  ```
  
## Documentation

Full documentation for Helm Chart (latest **stable** release) lives [on the website](https://airflow.apache.org/docs/helm-chart/).

Documentation related to the [parameters](https://airflow.apache.org/docs/helm-chart/stable/parameters-ref.html#)