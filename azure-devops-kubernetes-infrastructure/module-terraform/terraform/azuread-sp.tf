resource "random_string" "sp-aks-password" {
  length = 24
  special = true
}
resource "random_string" "sp-aks-secret" {
  length = 24
  special = true
}
resource "azuread_application" "sp-aks" {
  name  = "sp-aks-${var.aks_cluster_name}"
}
resource "azuread_service_principal" "sp-aks" {
  application_id                = "${azuread_application.sp-aks.application_id}"
  app_role_assignment_required  = false
}
resource "azuread_service_principal_password" "sp-aks" {
  service_principal_id  = "${azuread_service_principal.sp-aks.id}"
  value                 = "${random_string.sp-aks-password.result}"
  end_date_relative     = "8760h"

  lifecycle {
        ignore_changes = [
            value,
            end_date_relative
        ]
  }
}
resource "azuread_application_password" "sp-aks" {
  application_object_id = "${azuread_application.sp-aks.id}"
  value                 = "${random_string.sp-aks-secret.result}"
  end_date_relative     = "8760h"

  lifecycle {
        ignore_changes = [
            value,
            end_date_relative
        ]
  }
}