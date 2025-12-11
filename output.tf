output "role_assignments" {
  description = "The role assignments."
  value       = azurerm_role_assignment.this
}

### Debug Only

output "var_role_assignments" {
  value = var.role_assignments
}

output "local_role_assignments" {
  value = local.role_assignments
}
