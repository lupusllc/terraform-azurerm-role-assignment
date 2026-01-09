# Helps to combine data, easier debug and remove complexity in the main resource.

locals {
  role_assignments_list = [
    for index, role_assignment in var.role_assignments : {
      # Most will try and use key/value role_assignment first, then try applicable defaults and then null as a last resort.
      ### Basic

      condition                              = role_assignment.condition
      condition_version                      = role_assignment.condition_version
      delegated_managed_identity_resource_id = role_assignment.delegated_managed_identity_resource_id
      description                            = role_assignment.description
      index                                  = index # Added in case it's ever needed, since for_each/for loops don't have inherent indexes.
      name                                   = role_assignment.name
      principal_id                           = role_assignment.principal_id
      principal_type                         = role_assignment.principal_type
      role_definition_id                     = role_assignment.role_definition_id
      role_definition_name                   = role_assignment.role_definition_name
      scope                                  = role_assignment.scope
      scope_name                             = try(split("/", role_assignment.scope)[8], null) # Split out name to populate scope_name, if it's just a resource group scope it will be null.
      scope_resource_group_name              = try(split("/", role_assignment.scope)[4], null) # Split out resource group name to populate scope_resource_group_name.
      skip_service_principal_aad_check       = role_assignment.skip_service_principal_aad_check
      unique_for_each_id                     = role_assignment.unique_for_each_id
    }
  ]

  # Used to create unique id for for_each loops, as just using the name may not be unique.
  role_assignments = {
    # If unique_for_each_id is not null, use it directly.
    for role_assignment in local.role_assignments_list : role_assignment.unique_for_each_id != null ? role_assignment.unique_for_each_id :
    # If scope_name is null, use resource group name, principal ID and role definition name or ID, if null, as the unique ID.
    role_assignment.scope_name == null ?
    format(
      "%s>%s>%s",
      role_assignment.scope_resource_group_name,
      role_assignment.principal_id,
      coalesce(role_assignment.role_definition_name, role_assignment.role_definition_id)
    ) :
    # Otherwise, use resource group name, resource name, principal ID and role definition name or ID, if null, as the unique ID.
    format(
      "%s>%s>%s>%s",
      role_assignment.scope_resource_group_name,
      role_assignment.scope_name,
      role_assignment.principal_id,
      coalesce(role_assignment.role_definition_name, role_assignment.role_definition_id)
    )
    => role_assignment
  }
}
