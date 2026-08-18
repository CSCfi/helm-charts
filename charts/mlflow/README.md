# MLflow Helm Chart

A thin wrapper around the community [MLflow](https://mlflow.org) chart (vendored
under `charts/mlflow/`), adding an opt-in **basic authentication** layer for
deployment on CSC's Rahti / LUMI-K platforms.

## Overview

- This parent chart adds an `authentication` toggle. When enabled, it renders
  two Secrets (`templates/auth.yaml`).
- Two value files:
  - `values.yaml`: base profile, **no authentication** and **no ingress**.
  - `values-user-example.yaml`: example overlay that enables auth, S3 artifact storage
    and the public hostname.

## Prerequisites

- `helm` 3.x and the `oc` CLI, logged in to your OpenShift project.
- A backend store. The default is SQLite on a PVC; point `mlflow.mlflow.backendStoreUri`
  at your external PostgreSQL instance for production.
- (Optional but recommended) An S3 bucket + credentials for artifact storage.

## Deploy

**Basic Deployment:**

```sh
helm install mlflow .
```

**Advanced Deployment:**

The [`values-user-example.yaml`](./values-user-example.yaml) overlay enables basic authentication, exposes MLflow
through an ingress, and stores artifacts in S3. Before installing, copy it and fill in
the values that are **unique or secret to your deployment**:

- **Public hostname**: the same host in `mlflow.ingress.hosts[0].host`,
  `mlflow.server.value_options.allowed_hosts`, and `cors_allowed_origins`
  (the last one with an `https://` scheme).
- **Admin password**: `authentication.adminPassword`.


### Use of an Object Storage

It is possible to use CSC's Object storage services as the artifact store for MLflow. To do that, first, create credentials for Allas or LUMI-O service. Then, provide those as secret to your namespace in the following format.

```bash
oc create secret generic object-storage-creds --from-env-file=/dev/stdin <<'EOF'
AWS_ACCESS_KEY_ID=xxxx
AWS_SECRET_ACCESS_KEY=yyyy
MLFLOW_S3_ENDPOINT_URL=https://lumidata.eu
AWS_DEFAULT_REGION=lumi-prod
EOF
```

> To use Allas, set the `MLFLOW_S3_ENDPOINT_URL` to `https://a3s.fi` and `AWS_DEFAULT_REGION` to `us`.

Then use **s3cmd** tools to create a bucket. The following example bucket name is `mlflow`.

After creating the bucket, you can use the following commands to set the domain, password, and object storage credentials by installing the chart.

```bash
MLFLOW_DOMAIN=my-mlflow-namespace.<CLUSTER_DOMAIN>  # CLUSTER_DOMAIN for Rahti is .rahtiapp.fi and for LUMI-K is .apps.lumi-k.eu
helm install mlflow . -f values-user-example.yaml --set authentication.adminPassword=<STRONGPASSWORD> --set mlflow.envFrom[0].secretRef.name=object-storage-creds --set mlflow.mlflow.artifactsDestination="s3://mlflow/artifacts" --set mlflow.server.value_options.allowed_hosts=$MLFLOW_DOMAIN --set mlflow.server.value_options.cors_allowed_origins=https://$MLFLOW_DOMAIN --set mlflow.ingress.hosts[0].host=$MLFLOW_DOMAIN
```

> Note: Never commit real credentials. Pass secrets with `--set` at install time, or keep
> your edited copy of the file out of version control.


**Upgrade and uninstall as usual:**

```sh
helm upgrade mlflow . -f values-user-example.yaml
helm uninstall mlflow
```

## Authentication

Set `authentication.enabled: true` (done in `values-user-example.yaml`). The chart then:

- Creates Secret `mlflow-auth-config` holding `basic_auth.ini`.
- Creates Secret `mlflow-auth-secret` holding the Flask session key.
- Injects `--app-name=basic-auth`, the auth env vars, and the config volume mount
  into the MLflow server.

| Value | Description | Default |
|-------|-------------|---------|
| `authentication.enabled` | Enable basic auth | `false` |
| `authentication.adminPassword` | Initial admin password (user `admin`) | — |
| `authentication.database_uri` | Store for the auth DB | falls back to `mlflow.mlflow.backendStoreUri` |
| `authentication.flaskSecretKey` | Flask signing key; leave empty to auto-generate and preserve across upgrades | `""` |

> **Note on the auth flags:** `allowed_hosts` (server-side Host-header check) and
> `cors_allowed_origins` (browser CORS) must match your public hostname or the web
> UI will not load. They do **not** affect non-browser clients such as the Python
> `mlflow` SDK. See `values-user-example.yaml` for the hostname wiring.

## Configuration

Common values (all under the `mlflow:` key, passed to the subchart):

| Value | Description |
|-------|-------------|
| `mlflow.mlflow.backendStoreUri` | Tracking/metadata store URI |
| `mlflow.storage.enabled` / `size` | PVC for SQLite + artifacts |
| `mlflow.ingress.hosts[0].host` | Public hostname |
| `mlflow.server.value_options` | MLflow server CLI flags (`--key=value`) |
| `mlflow.garbageCollection` | Scheduled `mlflow gc` CronJob |

See [`charts/mlflow/values.yaml`](./charts/mlflow/values.yaml) (the vendored subchart) for the full list of
subchart options.
