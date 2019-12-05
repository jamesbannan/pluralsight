resource "tls_private_key" "aks" {
  algorithm = "RSA"
  rsa_bits  = 4096
}