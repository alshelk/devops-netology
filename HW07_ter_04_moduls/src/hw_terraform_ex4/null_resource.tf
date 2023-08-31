resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [module.test-vm]

  connection {
    type        = "ssh"
    user        = var.username
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = module.test-vm.external_ip_address[0]
    timeout     = "5m"
  }

#Ждем отработку cloud-init
  provisioner "remote-exec" {
    inline = [ "cloud-init status --wait" ]
  }

  triggers = {
      always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются
      playbook_src_hash  = file("${abspath(path.module)}/cloud-init.yml") # при изменении содержимого playbook файла
      ssh_public_key     = "${file("~/.ssh/id_rsa.pub")}" # при изменении переменной
  }

}