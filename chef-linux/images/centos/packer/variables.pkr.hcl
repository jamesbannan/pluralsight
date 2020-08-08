#######################################################
# Image Build Variables
#######################################################

variable "output_path" {
    type = string
    default = "../output"
}

variable "ssh_user" {
    type = string
    default = "vagrant"
}
variable "ssh_password" {
    type = string
    default = "vagrant"
}