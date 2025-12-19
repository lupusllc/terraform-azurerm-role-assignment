### Defaults

### Required

### Dependencies

### Resources

variable "role_assignments" {
  default     = [] # Defaults to an empty list.
  description = "Role Assignments."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type = list(object({
    ### Basic

    condition                              = optional(string, null) # The condition, changing requires recreation. Required if condition_version is specified.
    condition_version                      = optional(string, null) # The condition version, changing requires recreation.
    delegated_managed_identity_resource_id = optional(string, null) # The ID of the delegated managed identity resource. Changing requires recreation.
    description                            = optional(string, null) # The description of the role assignment. Changing requires recreation.
    name                                   = optional(string, null) # If not provided, a unique UUID/GUID will be generated.
    principal_id                           = string                 # The user, group, or service principal object ID to assign role. Changing requires recreation.
    principal_type                         = string                 # User, Group, ServicePrincipal. Changing requires recreation. This is required because it could fail on ABAC rules that filter base don this field.
    role_definition_id                     = optional(string, null) # The scoped ID of the role definition. Changing requires recreation.
    role_definition_name                   = optional(string, null) # The name of a built-in role. Changing requires recreation.
    scope                                  = string                 # The scope resource ID. Changing requires recreation.
    skip_service_principal_aad_check       = optional(bool, null)   # Skip the AAD check for service principals, in case they're newly created and not fully replicated. Defaults to false.

    ### Unique
    # Override unique ID used for for_each loops instead of using scope, this is needed for new resources since their resource ID isn't known yet.

    unique_for_each_id = optional(string, null)
  }))
}
