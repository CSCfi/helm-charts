# MLflow Helm Rahti2
## Getting started
[Helm](helm.sh), `oc` CLI and [openstack CLI](https://docs.csc.fi/cloud/pouta/install-client/) must be installed on your local machine.

## Introduction
This Helm chart deploys MLflow on Rahti2.

## Test and Deploy
Different steps are necessary to deploy this Helm Chart to Rahti2:  

1. If you want to use CSC external S3 service (Allas), be sure to create Allas credentials.  
   You can achieve this by [sourcing](https://docs.csc.fi/cloud/pouta/install-client/#configure-your-terminal-environment-for-openstack) your cPouta project and then type this command:  
     
     ```sh
     openstack ec2 credentials create
     ```
   
   Create also an Allas bucket for this deployment. (For example "mlflow")  

   You can also use another external S3 service instead of Allas.

2. Deploy MLflow:

     ```sh
     helm install mlflow . --set externalS3.accessKeyID={ACCESS_KEY} --set externalS3.accessKeySecret={SECRET_KEY} --set externalS3.bucket=mlflow
     ```

   _Replace {ACCESS_KEY} by the access key previously created_  
   _Replace {SECRET_KEY} by the secret key previously created_  
   _Replace {BUCKET_NAME} by the name of the bucket previously created_  

   Alternatively, you can edit the `values.yaml`:

     ```yaml
     externalS3:
       accessKeyID: ''
       accessKeySecret: ''
       bucket: 'mlflow'
     ```

To access MLflow tracking webpage, run this command to retrieve `user` password:  
```sh
echo Password: $(oc get secret --namespace {YOUR_NAMESPACE} mlflow-tracking -o jsonpath="{.data.admin-password }" | base64 -d)
```
_Replace {YOUR_NAMESPACE} by the name of your project in Rahti_   

You can edit the `config.yaml`. Instead of deleting your deployment and recreating a new one, Helm lets you `upgrade` your release. Use this command:  
```sh
helm upgrade mlflow . --set externalS3.accessKeyID={ACCESS_KEY} --set externalS3.accessKeySecret={SECRET_KEY} --set externalS3.bucket={BUCKET_NAME}
```

## Project status

## Links
[Bitnami MLflow README](https://github.com/bitnami/charts/blob/main/bitnami/mlflow/README.md)  