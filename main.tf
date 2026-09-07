locals {
  git_url        = "git::https://github.com/Friedmacher/tf_modules.git//modules/"
  module_version = "v1.6.3"
  user_names = [
    "manuel.friedmacher@sap.com"
  ]
}

/*
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
Enable Cloud Foundry in the subaccount and create a user for each user name in the list of user names. The users will be created with the given idp_origin.
*/
module "enable_cf" {
  source               = "git::https://github.com/manuel-friedmacher/tf_module_enable_cf"
  subaccount_id        = module.build_sa.subaccount_id
  subaccount_subdomain = module.build_sa.subaccount_subdomain
  cf_region            = var.cf_region
}

/* module "cf_space_add" {
  source        = "${local.git_url}cf_space_add?ref=${local.module_version}"
  cf_space_name = lower(var.project_name)
  cf_org_id     = module.cf_enable.cf_org_id
} */

/* module "cf_user_add" {
  source      = "${local.git_url}cf_user_add?ref=${local.module_version}"
  for_each    = toset(local.user_namess)
  user_name   = each.value
  idp_origin  = var.btp_platform_idp
  cf_org_id   = module.cf_enable.cf_org_id
  cf_space_id = module.cf_space_add.cf_space_id
} */

/* module "abap_add" {
  source                      = "${local.git_url}abap_add?ref=${local.module_version}"
  subaccount_id               = module.sa_build.subaccount_id
  cf_space_id                 = module.cf_space_add.cf_space_id
  cf_region                   = var.cf_region
  abap_sid                    = var.abap_sid
  abap_admin_email            = var.abap_admin_email
  abap_is_development_allowed = var.abap_is_development_allowed
} */

/*
Subcribe to the wz_add service in the subaccount and create a user for each user name in the list of user names. The users will be created with the given idp_origin.
*/
/*module "wz_add" {
  source           = "${local.git_url}wz_add?ref=${local.module_version}"
  subaccount_id    = module.sa_build.subaccount_id
  btp_platform_idp = var.btp_platform_idp
  cf_org_id        = module.cf_enable.cf_org_id
}*/
