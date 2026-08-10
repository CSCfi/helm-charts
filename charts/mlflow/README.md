# MLflow Helm Chart

A thin wrapper around the community [MLflow](https://mlflow.org) chart (vendored
under `charts/mlflow/`), adding an opt-in **basic authentication** layer for
deployment on CSC's Rahti / LUMI-K platform.

## Overview

- Checkout the [maintenance section](#maintainer-notes)
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

**Basic Deployment:**

```sh
helm install mlflow .
```

**Advanced Deployment:**

The `values-user-example.yaml` overlay enables basic authentication, exposes MLflow
through an ingress, and stores artifacts in S3. Before installing, copy it and fill in
the values that are **unique or secret to your deployment**:

- **Public hostname** — the same host in `mlflow.ingress.hosts[0].host`,
  `mlflow.server.value_options.allowed_hosts`, and `cors_allowed_origins`
  (the last one with an `http://` / `https://` scheme).
- **Admin password** — `authentication.adminPassword`.
- **S3 credentials & bucket** — `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`,
  `MLFLOW_S3_ENDPOINT_URL`, `AWS_DEFAULT_REGION` (env vars), and the bucket path in
  `mlflow.mlflow.artifactsDestination`.

> Note: Never commit real credentials. Pass secrets with `--set` at install time, or keep
> your edited copy of the file out of version control.

```sh
helm install mlflow . -f values-user-example.yaml
```

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

See `charts/mlflow/values.yaml` (the vendored subchart) for the full list of
subchart options.

## Maintainer Notes

To move to a newer MLflow release, replace the vendored subchart with the
`charts/` directory from the matching upstream tag and bump the versions:

```sh
VERSION=3.15.0
curl -sL "https://github.com/mlflow/mlflow/archive/refs/tags/v${VERSION}.tar.gz" | \
  tar xz "mlflow-${VERSION}/charts"
rm -rf charts/mlflow
mv "mlflow-${VERSION}/charts" charts/mlflow && rm -rf "mlflow-${VERSION}"
```

Then update:

- `version` and `appVersion` in this chart's `Chart.yaml` to `${VERSION}`.
- `dependencies[0].version` in `Chart.yaml` if upstream changed the subchart's
  own `version` (it must match `charts/mlflow/Chart.yaml` exactly, or
  `helm dependency build` fails).
- `mlflow.image.tag` in `values.yaml` to `v${VERSION}-full`.

Verify with `helm dependency build .`, `helm lint .` and `helm template .`
before opening a PR.
