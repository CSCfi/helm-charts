# OpenLDAP on OpenShift

This HELM chart deploys openLDAP on OpenShift and pre-populates it with some sample data using the LDIF format.

## Quick deploy

```sh
helm install openldap .
```

## LDIF files

Several LDIF files are added by two ConfigMaps (`openldap-init-ldif` and `openldap-schema`). Together they both: create a basic tree structure (on files `00-base.ldif`, `01-base-.ldif`), define new data types (on files `CSC-schema.ldif`, `02-CSCPrjActiveServices.ldif` and `03-CSCUserName.ldif`), and finally add sample projects ( on file `05-project.ldif`) and a sample user (on file `10-user.ldif`).

## OpenShift changes

1. Non-priviledged ports (>1024) are used. Standard LDAP is on port `389`, this solution exports port `1389`. Likewise with LDAPs, `636` becomes `1636`. Kubernentes Services can be used to remap to other ports.
1. File capabilities of the main binaries are reset (using `setcap -r`). This was necessary to let OpenShift execute the binaries.
