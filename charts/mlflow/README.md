# MLflow Helm Rahti

> [!IMPORTANT]  
> Starting on 29 September 2025, Bitnami will be changing its policy regarding its catalog. Read more [here](https://github.com/bitnami/containers/issues/83267)  
> - Current images will be moved to the [Bitnami Legacy Repository](https://hub.docker.com/u/bitnamilegacy) and will no longer be updated.  
> - Some images will still be available in the [Bitnami Secure Images](https://hub.docker.com/u/bitnamisecure) but only with the `latest` tag.  
> - To continue receiving images with the latest updates and access to different tags, you need to subscribe to the full version of Bitnami Secure Images: https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/  
> - Some of our Helm Charts used `Bitnami` images. Our Helm Charts are now intended for testing/development purposes because they use `bitnamilegacy` and/or `bitnamisecure` docker repositories.  
> - However, the Bitnami project continues to make its source code available at [bitnami/containers](https://github.com/bitnami/containers) under the Apache 2 license. You can build the image and then push it to your CSC project. You can find more information on how to push images [here](https://docs.csc.fi/cloud/rahti/images/Using_Rahti_integrated_registry/)


## Getting started
[Helm](helm.sh), `oc` CLI and [openstack CLI](https://docs.csc.fi/cloud/pouta/install-client/) must be installed on your local machine.

## Introduction
This Helm chart deploys MLflow on Rahti.

It is highly recommended to use the Helm CLI instead of the WebUI of Rahti. If so, you can clone the GitHub repository from [here](https://github.com/CSCfi/helm-charts).  
Helm CLI allows you:
- to download the necessary dependencies in order to run the chart, if you decide to run PostgreSQL and MinIO in Rahti.
- to set the necessary values (see command below), if you decide to run a PostgreSQL instance externally and to use an external S3 service.

## Test and Deploy
Different steps are necessary to deploy this Helm Chart to Rahti:  

1. By default, this Helm Chart will use the CSC S3 service Allas. Be sure to create Allas credentials.  
   You can achieve this by [sourcing](https://docs.csc.fi/cloud/pouta/install-client/#configure-your-terminal-environment-for-openstack) your cPouta project and then type this command:  
     
     ```sh
     openstack ec2 credentials create
     ```
   
   Create also an Allas bucket for this deployment. (For example "mlflow")  

   You can also use another external S3 service instead of Allas.

2. By default, it also uses our CSC database service named [Pukki](https://pukki.dbaas.csc.fi). Be sure to have a database created on this service.  
During the process of creation of database, it will ask you the `Allowed CIDRs`. Rahti has a common egress IP which is `86.50.229.150`. If you want a dedicated egress IP, you can send a ticket to [servicedesk@csc.fi](mailto:servicedesk@csc.fi). More information [here](https://docs.csc.fi/cloud/rahti/networking/#egress-ips).

   A database named `mlflow_auth` must be created when launching your instance. This database is needed for the auth module (only if `tracking.auth.enabled=true` which is the case by default).

3. Deploy MLflow:

     ```sh
     helm install mlflow . --set externalS3.accessKeyID={ACCESS_KEY} \
     --set externalS3.accessKeySecret={SECRET_KEY} \
     --set externalS3.bucket={BUCKET_NAME} \
     --set externalDatabase.host={DB_PUBLIC_IP} \
     --set externalDatabase.user={DB_USER} \
     --set externalDatabase.password={DB_PASSWORD} \
     --set externalDatabase.database={DB_NAME}
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

After the deployment, the Web URL will be displayed in the NOTES 

You can edit the `values.yaml`. Instead of deleting your deployment and recreating a new one, Helm lets you `upgrade` your release. Use this command:  
```sh
helm upgrade mlflow . --set externalS3.accessKeyID={ACCESS_KEY} --set externalS3.accessKeySecret={SECRET_KEY} --set externalS3.bucket={BUCKET_NAME}
```

## NOTES
You can use this template by deploying PostgreSQL and MINIO in Rahti. You can enable these parameters by editing the `values.yaml`:
```yaml
[...]
postgresql:
  enabled: true
[...]
minio:
  enabled: true
```

**It is highly recommended to use our other services (Pukki and Allas) in a production environment.**

If, for some reasons, the Rahti node crashes while you have PostgreSQL and MinIO running, it can cause disruptions and corruption in your database.  
Pukki also has automatic backups for your databases.
