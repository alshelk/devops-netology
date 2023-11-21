#resource "null_resource" "mhosts_provision" {
##Ждем создания инстанса
#depends_on = [yandex_compute_instance.mnode]
#
##Добавление ПРИВАТНОГО ssh ключа в ssh-agent
#  provisioner "local-exec" {
#    command = "cat ~/.ssh/id_rsa | ssh-add -"
#  }
#
##Костыль!!! Даем ВМ время на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
# provisioner "local-exec" {
#    command = "sleep 30"
#  }
#
##Запуск ansible-playbook
#  provisioner "local-exec" {
#    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/ansible/hosts.cfg ${abspath(path.module)}/ansible/playbook.yml"
#    on_failure = continue #Продолжить выполнение terraform pipeline в случае ошибок
#    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
#    #срабатывание триггера при изменении переменных
#  }
#    triggers = {
#      always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются
#      playbook_src_hash  = file("${abspath(path.module)}/ansible/playbook.yml") # при изменении содержимого playbook файла
#      ssh_public_key     = "${file("~/.ssh/id_rsa.pub")}" # при изменении переменной
#    }
#
#}

#resource "null_resource" "whosts_provision" {
##Ждем создания инстанса
#  depends_on = [yandex_compute_instance.wnode]
#
#  connection {
#    type        = "ssh"
#    user        = var.vm_metadata.ssh-user
#    private_key = "${file("~/.ssh/id_rsa.pub")}"
#    host        = yandex_compute_instance.wnode.network_interface.nat_ip_address
#    timeout     = "5m"
#  }
#
#  provisioner "file" {
#    source      = "./kubeadm.sh"
#    destination = "/tmp/kubeadm.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/kubeadm.sh",
#      "/tmp/kubeadm.sh",
#    ]
#  }
#
##Ждем отработку cloud-init
#  provisioner "remote-exec" {
#    inline = [ "cloud-init status --wait" ]
#  }
#
#  triggers = {
#      always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются
#      playbook_src_hash  = file("${abspath(path.module)}/kubeadm.sh") # при изменении содержимого playbook файла
#      ssh_public_key     = "${file("~/.ssh/id_rsa.pub")}" # при изменении переменной
#  }
#
#}