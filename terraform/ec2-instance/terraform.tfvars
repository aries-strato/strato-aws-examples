# .tfvars Sample File
# Remember to omit the .sample from the extension prior to running Terraform


# Region Credentials - CSM Cluster
#symphony_ip = "10.0.1.100"


# Region Credentials - demo10
symphony_ip = "10.16.96.40"
access_key = "8666089b023d4c00ad352ac2828de1b4"
secret_key = "4fc78a8d7eb0465cbb194bf53c191d8b"

# Reccomend for you to use Xenial's latest cloud image
# located here: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img 

# demo 10 ami
ami_image = "ami-4185cde610b14d68b2097d9774311ac3"

#CSM cluster ami
#ami_image = "ami-d509117f433144a2a6b714fa7f276ade"


# optional
# instance_type = "<instance-type>"
# instance_number = <number of instances>

