# ec2 main

data "aws_ami" "ubuntu-focal" {
  most_recent = false
  owners      = ["099720109477"]
  name_regex  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220610"
}

resource "aws_key_pair" "ubuntu-focal-public" {
  key_name   = "ubuntu-focal-public"
  public_key = file("/home/ubuntu/.ssh/ubuntu-focal-public.pub")
}

resource "aws_key_pair" "ubuntu-focal-private" {
  key_name   = "ubuntu-focal-private"
  public_key = file("/home/ubuntu/.ssh/ubuntu-focal-private.pub")
}

resource "aws_instance" "ubuntu-focal-private" {
  count                  = length(var.az_names)
  ami                    = data.aws_ami.ubuntu-focal.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = var.sg_map["private"].id[*]
  subnet_id              = var.subnets["private"][count.index].id
  private_ip             = cidrhost(var.private_cidrs[count.index], 4)
  root_block_device {
    volume_size = 10
  }

  user_data = templatefile("${path.module}/userdata.tpl",
    {
      nodename = "ubuntu-focal-private-${count.index + 1}"
  })

  key_name = aws_key_pair.ubuntu-focal-private.id

  lifecycle {
    ignore_changes = [tags]
  }

  tags = {
    Name = "ubuntu-focal-private-${count.index + 1}"
  }
}

resource "aws_instance" "ubuntu-focal-public" {
  count                  = 1 #length(var.az_names)
  ami                    = data.aws_ami.ubuntu-focal.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = var.sg_map["public"].id[*]
  subnet_id              = var.subnets["public"][count.index].id
  private_ip             = cidrhost(var.public_cidrs[count.index], 4)
  root_block_device {
    volume_size = 10
  }

  user_data = templatefile("${path.module}/userdata.tpl",
    {
      nodename = "bastion-node-${count.index + 1}"
  })

  key_name = aws_key_pair.ubuntu-focal-public.id

  tags = {
    Name = "bastion-node-${count.index + 1}"
  }
}