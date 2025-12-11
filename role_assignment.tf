### Requirements:

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54.0" # Tested on this provider version, but will allow future patch versions.
    }
  }
  required_version = "~> 1.14.0" # Tested on this Terraform CLI version, but will allow future patch versions.
}

### Data:

### Resources:

resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments

  ### Basic

  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  description                            = each.value.description
  name                                   = each.value.name
  principal_id                           = each.value.principal_id
  principal_type                         = each.value.principal_type
  role_definition_id                     = each.value.role_definition_id
  role_definition_name                   = each.value.role_definition_name
  scope                                  = each.value.scope
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
