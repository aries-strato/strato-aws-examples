# Overview - WebSockets with Symphony's ALB Example
This Terraform will create 2 (or more) webservers running the pywebsocket example from Google, put them behind an ALB, and includes an HTML file you can run from your PC with any web browser that supports web sockets (Latest FireFox and Chrome should work). 

`ami-<uuid without dashes>`

>This example's load balancer is configured as external, you can modify it to internal by modifying the alb-web.tf file

## Symphony Pre-requisite Check list
1. Ensure you have enabled and initialized load balancer service
2. Ensure you have imported an Ubuntu Xenial cloud image and made this image public, grab the AMI ID and insert it into your .tfvars file
3. Ensure your tenants project that you are deploying into has VPC mode enabled, with access keys generated (insert the access/secret keys into your .tfvars file)

## Getting started
1. Make sure you have the latest terraform installed
2. Create/Specify a security group
3. Modify the `terraform.tfvars` file according to your environment
4. Run `terraform apply`
5. After the solution is deployed, you should be able to go to the IP of your load balancer and refresh, each time it should redirect you to the other web server which is displaying it's instance ID so you know you're on a different server. 
