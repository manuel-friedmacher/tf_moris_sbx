locals {
  git_url        = "git::https://github.com/Friedmacher/tf_modules.git//modules/"
  module_version = "v1.6.3"
  user_names = [
    "manuel.friedmacher@sap.com"
  ]
}

/*
Step 1:
Create a subaccount with the name of the project and the given region. The subaccount will be created in the parent account with the given parent_id.
*/
module "build_sa" {
  /*source            = "${local.git_url}sa_build?ref=${local.module_version}"*/
  source            = "git::https://github.com/manuel-friedmacher/tf_module_build_sa"
  project_name      = var.project_name
  subaccount_region = var.subaccount_region
  stage             = var.stage
  parent_id         = var.parent_id
  btp_platform_idp  = var.btp_platform_idp
  btp_user_idp      = var.btp_user_idp
}

/*
Step 2:
Wait 30min to have the authentication and authorization of the subaccount fully propagated.
Enable Cloud Foundry in the subaccount and create a user for each user name in the list of user names. The users will be created with the given idp_origin.
*/
module "enable_cf" {
  source               = "git::https://github.com/manuel-friedmacher/tf_module_enable_cf"
  subaccount_id        = module.build_sa.subaccount_id
  subaccount_subdomain = module.build_sa.subaccount_subdomain
  cf_region            = var.cf_region
}

/*
Step 3:
  - subscribe to the SAP Build Workzone and SAP Task Center services
  - create a Cloud Foundry Space
  - assign an administrator to the Cloud Foundry Space
  - assign groups to the role collections
*/
module "add_workzone" {
  source           = "git::https://github.com/manuel-friedmacher/tf_module_workzone"
  subaccount_id    = module.build_sa.subaccount_id
  btp_platform_idp = var.btp_platform_idp
  cf_org_id        = module.enable_cf.cf_org_id
  cf_administrator = var.cf_administrator
}

/*
Step 4:
  - subscribe to the SAP BTP ABAP Environment
  - create a Cloud Foundry Space
  - assign an administrator to the Cloud Foundry Space
*/
module "add_abap" {
  source                      = "git::https://github.com/manuel-friedmacher/tf_module_abap"
  subaccount_id               = module.build_sa.subaccount_id
  btp_platform_idp            = var.btp_platform_idp
  cf_org_id                   = module.enable_cf.cf_org_id
  cf_administrator            = var.cf_administrator
  abap_sid                    = var.abap_sid
  abap_admin_email            = var.abap_admin_email
  abap_is_development_allowed = var.abap_is_development_allowed
}
