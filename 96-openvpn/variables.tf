variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "vpn_username" {
  default = "openvpn"
  type = string
}

variable "vpn_password" {
  type = string
  sensitive = true
}