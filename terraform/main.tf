provider "aws" {
    region     = var.region
}

module "ec2_instance" {
  source = "./ec2-instance"

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = var.tags
}

resource "null_resource" "upload_file" {
  depends_on = [module.ec2_instance]

  provisioner "file" {
    source      = "~/.ssh/id_rsa.pub"
    destination = "/home/ubuntu/id_rsa.pub"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Adjust based on your instance's user
      private_key = file("/home/jenkins_home/workspace/my_testing/ansible/satya.pem")
      host        = module.ec2_instance.instance_public_ip
    }
  }
}

resource "null_resource" "move_and_set_permissions" {
  depends_on = [null_resource.upload_file]

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/id_rsa.pub /home/ubuntu/.ssh/id_rsa.pub",
      "sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa.pub",
      "sudo chmod 600 /home/ubuntu/.ssh/id_rsa.pub"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Adjust based on your instance's user
      private_key = file("/home/jenkins_home/workspace/my_testing/ansible/satya.pem")
      host        = module.ec2_instance.instance_public_ip
    }
  }
}

resource "null_resource" "configure_ssh" {
  depends_on = [null_resource.move_and_set_permissions]

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i '/^PubkeyAuthentication /d' /etc/ssh/sshd_config",
      "echo 'PubkeyAuthentication yes' | sudo tee -a /etc/ssh/sshd_config",
      "sudo systemctl restart ssh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Adjust based on your instance's user
      private_key = file("/home/jenkins_home/workspace/my_testing/ansible/satya.pem")
      host        = module.ec2_instance.instance_public_ip
    }
  }
}
