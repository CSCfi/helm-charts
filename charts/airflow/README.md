<!--
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 -->

# Helm Chart for Apache Airflow

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/apache-airflow)](https://artifacthub.io/packages/search?repo=apache-airflow)

[Apache Airflow](https://airflow.apache.org/) is a platform to programmatically author, schedule and monitor workflows.

## Introduction

This chart will bootstrap an [Airflow](https://airflow.apache.org) deployment on a [OpenShift](http://okd.io)
cluster using the [Helm](https://helm.sh) package manager.

## Requirements

- Kubernetes 1.25+ cluster
- Helm 3.0+

## Deployment

As mentioned in the documentation, you must create a [Webserver Secret Key](https://airflow.apache.org/docs/helm-chart/stable/production-guide.html#webserver-secret-key). To do this, type this command:  

   ```sh
   oc create secret generic webserver-secret --from-literal="webserver-secret-key=$(python3 -c 'import secrets; print(secrets.token_hex(16))')"
   ```

Values from `posgresql.auth` must be defined. They must match with the values from `data.metadataConnection`

You can change the default user for the Webserver by modifying the values `webserver.defaultUser`

## Documentation

Full documentation for Helm Chart (latest **stable** release) lives [on the website](https://airflow.apache.org/docs/helm-chart/).

Documentation related to the [parameters](https://airflow.apache.org/docs/helm-chart/stable/parameters-ref.html#)