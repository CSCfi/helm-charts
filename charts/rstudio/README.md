# Rstudio Helm Chart
## TL;DR
```sh
helm upgrade --install rstudio .
```

## Explanations
This Helm Chart helps you to deploy Rstudio with Shiny on CSC Rahti 2 (Openshift 4).  
If you want to use it with different values, you can edit `values.yaml` file and then run:  
```sh
helm upgrade --install rstudio . -f {custom_values.yaml}
```

## Parameters
### Common parameters

| Name                                   | Description                                               | Value                                                        |
| -------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| `openshift.enabled`                    | If you are deploying on OKD 4                             | `true`                                                       |
| `appName`                              | Name for the application                                  | `csc-rstudio-shiny`                                          |
| `route.insecureEdgeTerminationPolicy`  | If `openshift.enabled`, will create a route               | `Redirect`                                                   |
| `route.termination`                    | If `openshift.enabled`, will create a route               | `edge`                                                       |
| `route.host`                           | If `openshift.enabled`, will create a route               | `""`                                                         |
| `buildConfig.gitRepoUri`               | Uri of the GitHub repo where the `Dockerfile` is located  | `https://github.com/CSCfi/helm-charts.git`                   |
| `buildConfig.gitBranch`                | Branch of the GitHub repo                                 | `main`                                                       |
| `buildConfig.contextDir`               | Context directory for the build                           | `charts/rstudio/source`                                      |

### Rstudio parameters

| Name                                   | Description                                             | Value                             |
| -------------------------------------- | ------------------------------------------------------- | --------------------------------- |
| `rstudio.podSecurityContext`           | Set SecurityContext for the pod                         | `{}`                              |
| `rstudio.containerSecurityContext`     | Set SecurityContext for the container                   | `allowPrivilegeEscalation: false`<br>`runAsUser:`<br>`runAsGroup:`<br>`capabilities:`<br>&nbsp;&nbsp;`drop:`<br>&nbsp;&nbsp;`- ALL`<br>`runAsNonRoot: true`<br>`seccompProfile:`<br>&nbsp;&nbsp;`type: RuntimeDefault` |
| `rstudio.pvc.mountName`                        | Name for the `PersistentVolumeClaim`            | `rstudio-server-home`             |
| `rstudio.pvc.storageSize`                      | Storage size for the `PersistentVolumeClaim`    | `5Gi`                             |

### Shiny parameters

| Name                                   | Description                                             | Value                             |
| -------------------------------------- | ------------------------------------------------------- | --------------------------------- |
| `shiny.pvc.mountName`                  | Name for the `PersistentVolumeClaim`                    | `shiny-server`                    |
| `shiny.pvc.storageSize`                | Storage size for the `PersistentVolumeClaim`            | `5Gi`                             |

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall rstudio
```

## Links
[Rstudio server configuration](https://docs.posit.co/ide/server-pro/rstudio-server-configuration.html)