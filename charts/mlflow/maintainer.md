## Instruction for Maintainers

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
