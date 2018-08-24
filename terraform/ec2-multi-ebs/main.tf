# Create instances, and name them according to count
resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_image}"

    tags{
        Name="instance${count.index}"
    }
    key_name = "demo10_aries5"
    
    instance_type = "${var.instance_type}"
    count="${var.instance_number}"

    root_block_device { 
        volume_size = 100
        volume_type = "sc1"
    }

}