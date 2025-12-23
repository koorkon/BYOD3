data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}
resource "random_id" "random_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}

resource "aws_key_pair" "deploy_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "web_server" {
  count                  = var.main_instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.project_sg.id]
  key_name               = aws_key_pair.deploy_key.key_name
  # user_data = templatefile("main-userdata.tpl", {
  #   new_hostname = "web-server-${random_id.random_node_id[count.index].dec}"
  # })
  tags = {
    Name = "web-server-${random_id.random_node_id[count.index].dec}-project"
  }
}
resource "null_resource" "write_ip" {
  triggers = {
    ip_list = join("", aws_instance.web_server.*.public_ip)
  }
  provisioner "local-exec" {
    command = "echo ${self.triggers.ip_list} > aws_hosts && bash create_inventory.sh"
  }
}
resource "null_resource" "cleanup" {
  provisioner "local-exec" {
    when    = destroy
    command = "wsl rm -f aws_hosts"
  }
}
locals {
  windows_key_path = var.private_key_path
  wsl_key_path     = replace(local.windows_key_path, "/mnt/c/Users/pc/", "~")
}


resource "null_resource" "graphana_provisioner" {
  depends_on = [aws_instance.web_server]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = aws_instance.web_server[0].public_ip
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      timeout     = "1m"
    }
    inline = ["echo 'Connection test successfully instance is reachable via ssh'"]
  }

  provisioner "local-exec" {
    interpreter = ["wsl", "bash", "-c"]
    command     = "ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook --private-key ~/.ssh/id_rsa_project playbooks/grafana.yml"
  }

  # provisioner "local-exec" {
  #   interpreter = ["wsl", "bash", "-c"]
  #   command     = "ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook --private-key ~/.ssh/id_rsa_project playbooks/prometheus.yml"
  # }
}
