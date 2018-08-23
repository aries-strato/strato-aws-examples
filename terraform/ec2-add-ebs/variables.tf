# Region Credentials
variable "symphony_ip" {}
variable "secret_key" {}
variable "access_key" {}
variable "ami_image" {}
variable "instance_number" {
  default = 20
}
variable "instance_type" {
  default = "t2.nano"
}

