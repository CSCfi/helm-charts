# MLflow Helm Chart

A thin wrapper around the community [MLflow](https://mlflow.org) chart (vendored
under `charts/`), adding an opt-in **basic authentication** layer for deployment
on CSC's Rahti / LUMI-K platform.

## Overview

- The upstream MLflow chart is vendored as a tarball in `charts/` (it is not
  published to a Helm repo), so no `helm dependency update` is needed.
- This parent chart adds an `authentication` toggle. When enabled, it renders
  two Secrets (`templates/auth.yaml`).
- Two value files:
  - `values.yaml` — base profile, **no authentication** (the default).
  - `values-user-example.yaml` — example overlay that enables auth, S3 artifact storage
    and the public hostname.

## Prerequisites

- `helm` 3.x and the `oc` CLI, logged in to your OpenShift project.
- A backend store. The default is SQLite on a PVC; point `mlflow.mlflow.backendStoreUri`
  at your external PostgreSQL instance for production.
- (Optional but recommended) An S3 bucket + credentials for artifact storage.

## Deploy

**Without authentication:**

```sh
helm install mlflow .
```

**With basic authentication** (layer the overlay on top of the base):

```sh
helm install mlflow . -f values-user-example.yaml
```

Upgrade and uninstall as usual:

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

See the vendored chart's `values.yaml` for the full list of subchart options.
