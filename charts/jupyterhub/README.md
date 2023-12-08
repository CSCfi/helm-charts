# JupyterHub Helm Rahti 2



## Getting started
[Helm](helm.sh) and `oc` CLI must be installed on your local machine.

## Introduction
This Helm chart deploys a JupyterHub/Notebook on Rahti 2.

## Test and Deploy

Clone this repo and then install the chart:
```sh
helm upgrade --install notebook .
```

You can now access your notebook.

## Project status
Admin account is `admin`.  
You have to define the password before accessing.  

If a new user want to access the notebook, he has to request access and then admin has to validate it through https://<notebook.com>/hub/authorize

## Links
https://z2jh.jupyter.org/en/latest/resources/reference.html  
https://github.com/jupyterhub/zero-to-jupyterhub-k8s