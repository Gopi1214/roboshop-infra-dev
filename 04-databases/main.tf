### mongodb

module "mongodb" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-mongodb"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.commn_tags,
    {
      Component = "mongodb"
    },
    {
      Name = "${local.ec2_name}-mongodb-g"
    }
  )
}

resource "null_resource" "mongodb" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mongodb.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    #host     = "${module.mongodb.private_ip}"
    host     = module.mongodb.private_ip
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
  depends_on = [module.mongodb]
}


### redis

module "redis" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-redis"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.commn_tags,
    {
      component = "redis"
    },
    {
      Name = "${local.ec2_name}-redis-g"
    }
  )
}

resource "null_resource" "redis" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.redis.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = module.redis.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
    ]
  }
}

### mysql

module "mysql" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-mysql"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_id
  iam_instance_profile   = "ShellScriptRoleForRoboshop"

  tags = merge(
    var.commn_tags,
    {
      component = "mysql"
    },
    {
      Name = "${local.ec2_name}-mysql-g"
    }
  )
}

resource "null_resource" "mysql" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mysql.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = module.mysql.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}

### rabbitmq

module "rabbitmq" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-rabbitmq"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_id
  iam_instance_profile   = "ShellScriptRoleForRoboshop"
  tags = merge(
    var.commn_tags,
    {
      component = "rabbitmq"
    },
    {
      Name = "${local.ec2_name}-rabbitmq-g"
    }
  )
}

resource "null_resource" "rabbitmq" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.rabbitmq.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = module.rabbitmq.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
}


# module "ansible" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   ami                    = data.aws_ami.centos8.id
#   name                   = "${local.ec2_name}-ansible"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
#   subnet_id              = data.aws_subnet.default.id
#   user_data              = file("ec2-provision.sh")
#   tags = merge(
#     var.commn_tags,
#     {
#       component = "ansible"
#     },
#     {
#       Name = "${local.ec2_name}-ansible-g"
#     }
#   )
# }

module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name = "mongodb-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.mongodb.private_ip}",
      ]
    },
    {
      name = "redis-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.redis.private_ip}",
      ]
    },
    {
      name = "mysql-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.mysql.private_ip}",
      ]
    },
    {
      name = "rabbitmq-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.rabbitmq.private_ip}",
      ]
    }
  ]

}