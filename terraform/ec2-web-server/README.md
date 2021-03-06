# Overview - EC2 Web Server
This terraform example will create 1 ubuntu instance, and install docker and launch an apache (httpd) container on it using the provided cloudinit file.
The cloudinit file will also query the metadata service in order to present the instance ID via the HTML file that is created on each instance. 
To get the ami id, simply fetch the image uuid from the Symphony UI, and convert it to the AWS format:
`ami-<uuid without dashes>`

## Getting started
1. Make sure you have the latest terraform installed
2. Make sure to use an ubuntu cloud image. Grab one [here](https://cloud-images.ubuntu.com/zesty/current/zesty-server-cloudimg-amd64.img)
3. Create/Import a keypair in Symphony
4. Create/Specify a security group
5. Modify the `terraform.tfvars` file according to your environment
6. Run `terraform apply`

## Notes
The script assumes the local default network can be routed using the existing edge network for the VPC enabled tenant. 
