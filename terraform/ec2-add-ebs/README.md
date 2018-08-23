# Overview - Simple EC2 Instance with EBS volume specified
This terraform example creates a very simple ec2 instance from an ami.  
To get the ami id, simply fetch the image uuid from the Symphony UI, and convert it to the AWS format:
`ami-<uuid without dashes>`

## Getting started
1. Make sure you have the latest terraform installed
2. Modify the `terraform.tfvars.sample` file according to your environment (don't forget to omit the .sample extension prior to running)
3. Run `terraform apply`

## How to set an alias for your Symphony storage pool
1. Log into Symp CLI
2. Get the UUID of your pool (storage pools list -c id -c name)
3. Set the alias of your desired pool with the following command:  
`storage pool update --pool-id [pool id] --alias [alias]`

Example:
```
Symphony > storage pool list -c id -c name
+--------------------------------------+------+
| id                                   | name |
+--------------------------------------+------+
| d52801b6-0be9-40ad-b438-ebafa429d293 | Pool |
| c2b70e37-bde8-4be9-a1d6-6300cc1c4802 | slow |
+--------------------------------------+------+
Symphony > storage pool update --pool-id c2b70e37-bde8-4be9-a1d6-6300cc1c4802 --alias sc1
+-------+---------+
| Field | Value   |
+-------+---------+
| value | Success |
+-------+---------+
```
4. Your options for the alias are either `sc1`, `io1`, `st1`, and `gp2`
5. You can then specify the volume_type in Terraform
