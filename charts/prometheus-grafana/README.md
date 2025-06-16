# Grafana and Prometheus Helm Chart

## TL;DR

```sh
helm upgrade --install graf-prom .
```

## Explanations

This Helm Chart helps you to deploy Grafana and Prometheus on CSC Rahti (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install graf-prom . -f {custom_values.yaml}
```

The password to access Grafana WebUI is generated randomly and won't change if you upgrade your chart.

## Parameters

We created a default `values.yaml` file that is compatible with our platform Rahti. This Helm Chart is using the official from Prometheus and Grafana.
Take a look:

- [Prometheus Community](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/README.md)
- [Grafana](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md)

There is one mandatory field that you must fill out:

- `prometheus.serverFiles.prometheus.yml.scrape_configs.2.kubernetes_sd_configs.0.namespaces.names.0`
  ```yaml
  - job_name: 'kubernetes-pods'
    honor_labels: true
    kubernetes_sd_configs:
      - role: pods
        namespaces:
          names:
            -  # Enter the name of your namespace/project here
  ```

In order to have your pods monitored by Prometheus, you need to add these annotations:

* `prometheus.io/scrape`: Only scrape pods that have a value of `true`,
* `prometheus.io/path`: If the metrics path is not `/metrics` override this.
* `prometheus.io/port`: Scrape the pod on the indicated port instead of the default of `9102`.

You can also deploy [Prometheus statsd exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-statsd-exporter).

By default, the value is set to `false`. Change the value to `true` to deploy it:

```yaml
statsd-exporter:
  enabled: true
```

## Cleanup

To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall graf-prom
```