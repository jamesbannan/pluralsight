variable certificate_permissions_all {
  description   = "Certificate action permissions in the Key Vault."
  type          = list
  default       = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "purge",
      "recover",
      "setissuers",
      "update"
  ]
}
variable key_permissions_all {
  description   = "Key action permissions in the Key Vault."
  type          = list
  default       = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey"
  ]
}
variable secret_permissions_all {
  description   = "Secret action permissions in the Key Vault."
  type          = list
  default       = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set"
  ]
}