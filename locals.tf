# Helps to combine data, easier debug and remove complexity in the main resource.

locals {
  role_assignments_list = [
    for index, settings in var.role_assignments : {
      # Most will try and use key/value settings first, then try applicable defaults and then null as a last resort.
      ### Basic

      condition                              = settings.condition
      condition_version                      = settings.condition_version
      delegated_managed_identity_resource_id = settings.delegated_managed_identity_resource_id
      description                            = settings.description
      index                                  = index # Added in case it's ever needed, since for_each/for loops don't have inherent indexes.
      name                                   = settings.name
      principal_id                           = settings.principal_id
      principal_type                         = settings.principal_type
      role_definition_id                     = settings.role_definition_id
      role_definition_name                   = settings.role_definition_name
      scope                                  = settings.scope
      scope_name                             = try(split("/", settings.scope)[8], null) # Split out name to populate scope_name, if it's just a resource group scope it will be null.
      scope_resource_group_name              = try(split("/", settings.scope)[4], null) # Split out resource group name to populate scope_resource_group_name.
      skip_service_principal_aad_check       = settings.skip_service_principal_aad_check
      unique_for_each_id                     = settings.unique_for_each_id
    }
  ]

  # Used to create unique id for for_each loops, as just using the name may not be unique.
  role_assignments = {
    # If scope_name is null, use resource group name, principal ID and role definition name or ID, if null, as the unique ID.
    for index, settings in local.role_assignments_list : settings.unique_for_each_id != null ? settings.unique_for_each_id :
    settings.scope_name == null ?
    format(
      "%s>%s>%s",
      settings.scope_resource_group_name,
      settings.principal_id,
      coalesce(settings.role_definition_name, settings.role_definition_id)
    ) :
    # Otherwise, use resource group name, resource name, principal ID and role definition name or ID, if null, as the unique ID.
    format(
      "%s>%s>%s>%s",
      settings.scope_resource_group_name,
      settings.scope_name,
      settings.principal_id,
      coalesce(settings.role_definition_name, settings.role_definition_id)
    )
    => settings
  }
}
