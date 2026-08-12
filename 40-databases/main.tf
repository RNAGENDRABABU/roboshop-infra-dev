resource "aws_instance" "mongodb" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.database_subnet_id
  vpc_security_group_ids = [local.mongodb_sg_id]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-mongodb"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        password    = "DevOps321"
        host        = aws_instance.mongodb.private_ip

        bastion_host = "44.203.34.73"
        bastion_user = "ec2-user"
        bastion_password = "DevOps321"
    }

    provisioner "file" {
      source = "bootstrap.sh" # Local file path
      destination = "/tmp/bootstrap.sh" # Remote destination path
    }    

    provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mongodb"
      ]
    }
}

resource "aws_instance" "redis" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.database_subnet_id
  vpc_security_group_ids = [local.redis_sg_id]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-redis"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap_redis" {
    triggers_replace = [
        aws_instance.redis.id
    ]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        password    = "DevOps321"
        host        = aws_instance.redis.private_ip

        bastion_host = "44.203.34.73"
        bastion_user = "ec2-user"
        bastion_password = "DevOps321"
    }

    provisioner "file" {
      source = "bootstrap.sh" # Local file path
      destination = "/tmp/bootstrap.sh" # Remote destination path
    }    

    provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh redis"
      ]
    }
}