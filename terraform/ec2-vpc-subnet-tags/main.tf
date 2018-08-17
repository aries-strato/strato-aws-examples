

# Creating a VPC & Networking

# VPC creation
resource "aws_vpc" "myapp_vpc" {
  cidr_block = "192.168.0.0/16"
  tags {
    Name = "Demo VPC"
  }
}

# DNS resolver, forwarding to Google DNS 
# NTP server is IP of time.google.com
resource "aws_vpc_dhcp_options" "foo" {
  domain_name = "test.local"
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
  ntp_servers = ["216.239.35.12"]
  tags {
    Name = "Demo"
  }
}

# Associating DNS resolver with the DHCP Options association which will be attached to the Demo VPC

resource "aws_vpc_dhcp_options_association" "foo" {
  vpc_id          = "${aws_vpc.myapp_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.foo.id}"
}

# Private Subnet 1 creation 
resource "aws_subnet" "private1_subnet"{
    cidr_block = "192.168.10.0/24"
    vpc_id = "${aws_vpc.myapp_vpc.id}"
    tags {
      Name = "Demo subnet"
      Tier = "private"
    }
    # Makes sure DHCP configuration is absorbed in the subnet - Symphony specific
    depends_on = ["aws_vpc_dhcp_options_association.foo"]
}

# Private Subnet 2 creation 
resource "aws_subnet" "private2_subnet"{
    cidr_block = "192.168.11.0/24"
    vpc_id = "${aws_vpc.myapp_vpc.id}"
    tags {
      Name = "Demo subnet"
      Tier = "private"
    }
    # Makes sure DHCP configuration is absorbed in the subnet - Symphony specific
    depends_on = ["aws_vpc_dhcp_options_association.foo"]
}

# Public Subnet 1 creation 
resource "aws_subnet" "public1_subnet"{
    cidr_block = "192.168.20.0/24"
    vpc_id = "${aws_vpc.myapp_vpc.id}"
    tags {
      Name = "Demo subnet"
      Tier = "public"
    }
    # Makes sure DHCP configuration is absorbed in the subnet - Symphony specific
    depends_on = ["aws_vpc_dhcp_options_association.foo"]
}

# Public Subnet 2 creation 
resource "aws_subnet" "public2_subnet"{
    cidr_block = "192.168.21.0/24"
    vpc_id = "${aws_vpc.myapp_vpc.id}"
    tags {
      Name = "Demo subnet"
      Tier = "public"
    }
    # Makes sure DHCP configuration is absorbed in the subnet - Symphony specific
    depends_on = ["aws_vpc_dhcp_options_association.foo"]
}

# Pulling data resource for private subnet
data "aws_subnet_ids" "private" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  tags {
    Tier = "private"
  }
}

# Pulling data for public subnet
data "aws_subnet_ids" "public" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  tags {
    Tier = "public"
  }
}

# Internet gateway 

resource "aws_internet_gateway" "myapp_gw" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
}

# The default route table will allow each subnet to route to the Internet Gateway
resource "aws_default_route_table" "default" {
    default_route_table_id = "${aws_vpc.myapp_vpc.default_route_table_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.myapp_gw.id}"
    }
}


############ Instance Creation #############################

# Creating instances for private subnets
resource "aws_instance" "private_instance" {
    ami = "${var.ami_my_image}"
    count = "${var.instance_number}"
    instance_type = "${var.instance_type}"
    subnet_id = "${element(data.aws_subnet_ids.private.ids, count.index)}" 
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    count = "${var.instance_number}"
    # My key for testing
    key_name = "tf_demo10"
    tags{
        Name="private_instance_${count.index}"
    }
}

# Creating instances for public subnets
resource "aws_instance" "public_instance" {
    ami = "${var.ami_my_image}"
    count = "${var.instance_number}"
    instance_type = "${var.instance_type}"
    subnet_id = "${element(data.aws_subnet_ids.private.ids, count.index)}" 
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    count = "${var.instance_number}"
    # My key for testing
    key_name = "tf_demo10"
    tags{
        Name="public_instance_${count.index}"
    }
}

# Elastic IP Allocation for private instances

resource "aws_eip" "private_instance_eip" {
  count = "${var.instance_number}"
  depends_on = ["aws_internet_gateway.myapp_gw"]
}

# Elastic IP Allocation for public instances

resource "aws_eip" "public_instance_eip" {
  count = "${var.instance_number}"
  depends_on = ["aws_internet_gateway.myapp_gw"]
}

# Associating EIP with private instances that get deployed

resource "aws_eip_association" "myapp_eip_assoc" {
  count = "${var.instance_number}"
  instance_id = "${element(aws_instance.private_instance.*.id, count.index)}"
  allocation_id = "${element(aws_eip.private_instance_eip.*.id, count.index)}"
}

# Associating EIP with public instances that get deployed

resource "aws_eip_association" "myapp_eip_assoc" {
  count = "${var.instance_number}"
  instance_id = "${element(aws_instance.public_instance.*.id, count.index)}"
  allocation_id = "${element(aws_eip.public_instance_eip.*.id, count.index)}"
}


################## Security Group ##################

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"
  vpc_id      = "${aws_vpc.myapp_vpc.id}"

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
