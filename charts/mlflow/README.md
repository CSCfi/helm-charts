# MLflow Helm Rahti2
## Getting started
[Helm](helm.sh), `oc` CLI and [openstack CLI](https://docs.csc.fi/cloud/pouta/install-client/) must be installed on your local machine.

## Introduction
This Helm chart deploys MLflow on Rahti2.

It is highly recommended to use the Helm CLI instead of the WebUI of Rahti2. If so, you can clone the GitHub repository from [here](https://github.com/CSCfi/helm-charts)

## Test and Deploy
Different steps are necessary to deploy this Helm Chart to Rahti2:  

1. By default, this Helm Chart will use the CSC S3 service Allas. Be sure to create Allas credentials.  
   You can achieve this by [sourcing](https://docs.csc.fi/cloud/pouta/install-client/#configure-your-terminal-environment-for-openstack) your cPouta project and then type this command:  
     
     ```sh
     openstack ec2 credentials create
     ```
   
   Create also an Allas bucket for this deployment. (For example "mlflow")  

   You can also use another external S3 service instead of Allas.

2. By default, it also uses our CSC database service named [Pukki](https://pukki.dbaas.csc.fi). Be sure to have a database created on this service.  
During the process of creation of database, it will ask you the `Allowed CIDRs`. Rahti2 has a common egress IP which is `86.50.229.150`. If you want a dedicated egress IP, you can send a ticket to [servicedesk@csc.fi](mailto:servicedesk@csc.fi). More information [here](https://docs.csc.fi/cloud/rahti2/networking/#egress-ips).

   A database named `mlflow_auth` must be created when launching your instance. This database is needed for the auth module (only if `tracking.auth.enabled=true` which is the case by default).

3. Deploy MLflow:

     ```sh
     helm install mlflow . --set externalS3.accessKeyID={ACCESS_KEY} --set externalS3.accessKeySecret={SECRET_KEY} --set externalS3.bucket={BUCKET_NAME} --set externalDatabase.host={DB_PUBLIC_IP} --set externalDatabase.user={DB_USER} --set externalDatabase.password={DB_PASSWORD} --set externalDatabase.database={DB_NAME}
     ```

   _Replace {ACCESS_KEY} by the access key previously created_  
   _Replace {SECRET_KEY} by the secret key previously created_  
   _Replace {BUCKET_NAME} by the name of the bucket previously created_  
   _Replace {DB_PUBLIC_IP} by the public IP of your databse created on Pukki_  
   _Replace {DB_USER} by the user created on Pukki_  
   _Replace {DB_NAME} by the database created on Pukki_ 

   Alternatively, you can edit the `values.yaml`:

     ```yaml
     [...]
     externalDatabase:
       host: ''
       user: ''
       database: ''
       password: ''
     [...]
     externalS3:
       accessKeyID: ''
       accessKeySecret: ''
       bucket: ''
     ```

After the deployment, the Web URL will be displayed in the NOTES. To access MLflow tracking webpage, run this command to retrieve `user` password:  
```sh
echo Password: $(oc get secret --namespace {YOUR_NAMESPACE} mlflow-tracking -o jsonpath="{ .data.admin-password }" | base64 -d)
```
_Replace {YOUR_NAMESPACE} by the name of your project in Rahti_   

You can edit the `values.yaml`. Instead of deleting your deployment and recreating a new one, Helm lets you `upgrade` your release. Use this command:  
```sh
helm upgrade mlflow . --set externalS3.accessKeyID={ACCESS_KEY} --set externalS3.accessKeySecret={SECRET_KEY} --set externalS3.bucket={BUCKET_NAME}
```

## NOTES
You can use this template by deploying PostgreSQL and MINIO in Rahti2. You can enable these parameters by editing the `values.yaml`:
```yaml
[...]
postgresql:
  enabled: true
[...]
minio:
  enabled: true
```

**It is highly recommended to use our other services (Pukki and Allas) in a production environment.**

## Project status

## Links
[Bitnami MLflow README](https://github.com/bitnami/charts/blob/main/bitnami/mlflow/README.md)  