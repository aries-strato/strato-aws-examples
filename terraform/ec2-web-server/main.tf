# VPC and subnet creation

resource "aws_vpc" "default" {
    cidr_block = "10.48.0.0/16"
    enable_dns_support = true
  tags {
    Name = "EC2 Web Sample VPC"
  }
}

resource "aws_subnet" "subnet1"{
    cidr_block = "10.48.1.0/24"
    vpc_id = "${aws_vpc.default.id}"

    tags {
      Name = "Web subnet"
  }
}

# add dhcp options
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
  
}

# associate dhcp with vpc
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.default.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}


# create igw
resource "aws_internet_gateway" "app_igw" {
  vpc_id = "${aws_vpc.default.id}"
}

#new default route table with igw association 

resource "aws_default_route_table" "default" {
   default_route_table_id = "${aws_vpc.default.default_route_table_id}"

   route {
       cidr_block = "0.0.0.0/0"
       gateway_id = "${aws_internet_gateway.app_igw.id}"
   }
}




###################################
# Cloud init data

data "template_file" "webconfig" {
  template = "${file("./webconfig.cfg")}"
}

data "template_cloudinit_config" "web_config" {
  gzip = false
  base64_encode = false

  part {
    filename     = "webconfig.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.webconfig.rendered}"
  }
}

###################################

# Creating instances of web server ami with cloudinit
resource "aws_instance" "web" {
    
    ami = "${var.ami_webserver}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.subnet1.id}"

    vpc_security_group_ids = ["${aws_security_group.web-sec.id}", "${aws_security_group.allout.id}"]
    user_data = "${data.template_cloudinit_config.web_config.rendered}"

    tags {
    Name = "WebServer-${count.index}"
  }

  count = "${var.web_number}"
}