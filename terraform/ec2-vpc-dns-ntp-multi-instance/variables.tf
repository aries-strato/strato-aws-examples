# Region Credentials
variable "symphony_ip" {}
variable "secret_key" {}
variable "access_key" {}

# Main variables
variable "ami_my_image" {}
variable "instance_number" {
  default = 1
}
variable "instance_type" {
  default = "t2.micro"
}
