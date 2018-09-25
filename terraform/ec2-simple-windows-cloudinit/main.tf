# Create instances, and name them according to count

# Defining cloud config template file 

data "template_file" "clouddeploy"{
  template = "${file("./cloudconfig.cfg")}"
}

data "template_cloudinit_config" "clouddeploy_config" {
  gzip = false
  base64_encode = false

  part {
    filename     = "cloudconfig.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.clouddeploy.rendered}"
  }
}


resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_image}"

    tags{
        Name="instance${count.index}"
    }
    
    instance_type = "${var.instance_type}"
    count="${var.instance_number}"

    user_data = "${data.template_cloudinit_config.clouddeploy_config.rendered}"

}