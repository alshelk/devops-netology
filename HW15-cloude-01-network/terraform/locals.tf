locals {
  ssh-keys  = "${var.ssh_user}:${file("~/.ssh/id_rsa.pub")}"
}

