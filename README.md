# Terraform - MoRIS Sandbox
Create the MoRIS Sandbox environment.

# Prepare
## Devcontainer
Update the file **devcontainer.env** in the **.devcontainer** folder, which includes the necessary environment variables:
- BTP_USERNAME
- BTP_PASSWORD
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- CF_USER
- CF_PASSWORD
- CF_ORIGIN

## Variables
Create a file **terraform.tfvars** with the following varabels and maintain the correct values in it.
| Variable | Description |
| --- | --- |
| global_account | ID of the subaccount to be trusted. |
| project_name | Name of the project, this terraform script belongs to. The project name is used to derife the subaccount name from it. |  
| subaccount_region | The data center region, the subaccount shall be created in. (e.g. "eu10", "eu11", "eu20", "eu22", "eu30", "eu31) |
| stage | The development stage, the subaccount belongs to. (e.g. "SBX", "DEV", "QAS", "PRD") |
| parent_id | The UUID of the directory, the subaccount shall be created in. |
| btp_platform_idp | FQDN of the platform Identity Provider (IdP). |
| btp_user_idp | FQDN of the Identity Provider (IdP) to be trusted. |
| cf_region | Cloud Foundry datacenter region |
| cf_administrator | Administrator user to be added to the Cloud Foundry Org and Spaces |
| cf_api_url | URL of the Cloud Foundry API
| abap_sid | SID of the SAP BTP ABAP Environment |
| abap_admin_email | Administrator user to be added to the SAP BTP ABAP Environment |
| abap_is_development_allowed | Is the SAP BTP ABAP Environment enabled for development |

# Run
Run the following terraform commands in an terminal within the devcontainer:
```shell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
````

# Update
When changing the version of a provider, run the following command:
```shell
terraform init -upgrade
```

When something was changed manually, run the following command:
```shell
terraform apply -refresh-only
```
