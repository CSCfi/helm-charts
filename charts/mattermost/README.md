# Mattermost Helm Chart

This Helm Chart deploys Mattermost Enterprise Edition. If you don't own a license, it will run Mattermost Entry Edition which is a limited version of Mattermost Enterprise Edition.

More information about Mattermost Entry edition: https://docs.mattermost.com/product-overview/editions-and-offerings.html#mattermost-entry

Compare the plans: https://mattermost.com/pricing/

> [!IMPORTANT]  
> CSC doesn't provide the licenses

# Prerequisites

## External services:

Before deploying, you must have:

- An external database: PostgreSQL 11+

  You can use our Database as a Service called [Pukki](https://docs.csc.fi/cloud/dbaas/). _You might need to enable it on [MyCSC](https://my.csc.fi)_

- An external File Storage: S3-compatible object storage (AWS S3, GCS, MinIO, etc...)

  You can use our S3 Storage Service called [Allas](https://allas.csc.fi) or [Lumi-O](https://docs.lumi-supercomputer.eu/storage/lumio/auth-lumidata-eu/). _You might need to enable it on [MyCSC](https://my.csc.fi)_

## Helm

It's higly recommended to use the [Helm CLI tool](https://helm.sh) to install this Chart.

# Configuration

We created a default `values.yaml` file that is compatible with our Container platforms Rahti and Lumi-K.

You will still need to enter your own values.

Before deploying the application, you must create **two secrets**: `mattermost-db` and `mattermost-s3-cred`.

Run these commands:

- For the postgreSQL connection string:

```
oc create secret generic mattermost-db \
--from-literal="mattermost.dbsecret=postgres://<user>:<password>@<db_public_IP>:5432/<database>?sslmode=require"
```

Replace the values bywith your own configuration that you created when setting up the database on [Pukki](https://pukki.dbaas.csc.fi)

- For the Lumi-O/Allas S3 credentials:

```
oc create secret generic mattermost-s3-creds \
--from-literal=accessKeyId="" \
--from-literal=secretAccessKey=""
```

To create Allas S3 credentials, please refer to our documentation: https://docs.csc.fi/support/faq/how-to-get-Allas-s3-credentials/

To create Lumi-O credentials, please refer to our documentation: https://docs.lumi-supercomputer.eu/storage/lumio/auth-lumidata-eu/

Once the secrets created, you need to edit the values file. Some fields are mandatory in order for the application to be operational.

## Required settings

1. `route.host` - Host address of you application
1. `mattermost.global.siteURL` - URL users will access Mattermost at. Must be the same as `route.host` with `https://`
1. `mattermost.global.mattermostLicense` - Your Mattermost Enterprise license (optional, but recommended)
1. `mattermost.global.features.database.driver` - Database type: `postgres`
1. `mattermost.global.features.fileStore.driver` - File storage driver: `amazons3` or `local`
1. `mattermost.global.features.fileStore.url` - Allas: `a3s.fi` / Lumi-O: `lumidata.eu`
1. `mattermost.global.features.fileStore.bucket` - S3 bucket name (when using `amazons3`)
1. `mattermost.global.features.fileStore.region` - Allas: `regionOne` / Lumi-O: `lumi-prod`

Finally, you can run the commands:

- If you have cloned the repository on your computer:

```
helm dependency update
helm install mattermost . -f values.yaml
```

- If you have added the repo previously with the command `helm repo add csc https://cscfi.github.io/helm-charts/`, run:

```
helm install mattermost csc/mattermost -f values.yaml
```

Follow the instructions printed in the terminal.
Wait for a few minutes and your applications should be available at the address specified in the value `mattermost.global.siteUrl`