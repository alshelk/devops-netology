resource "null_resource" "hosts_provision" {
#Ждем создания инстанса
  depends_on = [yandex_compute_instance.wnode, yandex_compute_instance.mnode]

  count = length(local.servers_list)

  connection {
    type        = "ssh"
    user        = var.vm_metadata.ssh-user
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = local.servers_list[count.index].network_interface.0.nat_ip_address
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "./kubeadm.sh"
    destination = "/tmp/kubeadm.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kubeadm.sh",
      "/tmp/kubeadm.sh",
    ]
  }

  triggers = {
    always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash  = file("${abspath(path.module)}/kubeadm.sh") # при изменении содержимого playbook файла
    ssh_public_key     = "${file("~/.ssh/id_rsa.pub")}" # при изменении переменной
  }

}