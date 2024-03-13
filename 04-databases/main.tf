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
      component = "mongodb"
    },
    {
      Name = "${local.ec2_name}-mongodb-g"
    }
  )
}

resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = module.mongodb.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type = "ssh"
    user = "centos"
    password = "DevOps321"
    host = [module.mongodb.private_ip]
    
  }

   provisioner "file" {
        source      = "bootstarp.sh"
        destination = "/tmp/bootstarp.sh"
      }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstarp.sh",
      "sudo sh /tmp/bootstarp.sh"
    ]
  }
}

# module "mysql" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "${local.ec2_name}-mysql"
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
#   subnet_id              = local.database_subnet_id

#   tags = merge(
#     var.commn_tags,
#     {
#       component = "mysql"
#     },
#     {
#       Name = "${local.ec2_name}-mysql-g"
#     }
#   )
# }

# module "redis" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "${local.ec2_name}-redis"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
#   subnet_id              = local.database_subnet_id

#   tags = merge(
#     var.commn_tags,
#     {
#       component = "redis"
#     },
#     {
#       Name = "${local.ec2_name}-redis-g"
#     }
#   )
# }

# module "rabbitmq" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   name                   = "${local.ec2_name}-rabbitmq"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
#   subnet_id              = local.database_subnet_id

#   tags = merge(
#     var.commn_tags,
#     {
#       component = "rabbitmq"
#     },
#     {
#       Name = "${local.ec2_name}-rabbitmq-g"
#     }
#   )
# }


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
      name = "mongodb"
      type = "A"
      ttl  = 1
      records = [
        "${module.mongodb.private_ip}",
      ]
    },
    # {
    #   name = "redis"
    #   type = "A"
    #   ttl  = 1
    #   records = [
    #     "${module.redis.private_ip}",
    #   ]
    # },
    # {
    #   name = "mysql"
    #   type = "A"
    #   ttl  = 1
    #   records = [
    #     "${module.mysql.private_ip}",
    #   ]
    # },
    # {
    #   name = "rabbitmq"
    #   type = "A"
    #   ttl  = 1
    #   records = [
    #     "${module.rabbitmq.private_ip}",
    #   ]
    # }
  ]

}