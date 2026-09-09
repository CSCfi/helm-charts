# GitLab Runner Helm Chart

This chart deploys a GitLab Runner instance into Rahti or Lumi-K cluster.

## Explanations

This Helm Chart contains default value to run on Rahti or Lumi-K clusters.

First of all, you must request a dedicated Rahti Egress IP by sending an email to `servicedesk@csc.fi`

Once you got the dedicated IP, you must contact `cscci@csc.fi` to provide the network access to CSC GitLab.

You must set `.Values.runnerToken` that you can obtain when you create a runner in the GitLab UI

Once set, you can install the Helm Chart by running this command:

```sh
helm dependency update
helm install gitlab-runner . -f values.yaml
```

You can find more information about the `values.yaml` in the official Helm Chart repoistory:

- https://gitlab.com/gitlab-org/charts/gitlab-runner

Here is the link to the official documentation on how to install the Helm Chart:

- https://docs.gitlab.com/runner/install/kubernetes/

## Cleanup

To delete all the resources, simply uninstall the Helm Chart:

```sh
helm uninstall gitlab-runner
```
