
# создаем сервесный акаунт
resource "yandex_iam_service_account" "tfstate" {
  name        = "tfstate"
  description = "Account for terraform tfstate"
  folder_id   = var.folder_id
}

# назаначаем права на сервесный аккаунт
resource "yandex_resourcemanager_folder_iam_binding" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.tfstate.id}"
  ]
  depends_on = [yandex_iam_service_account.tfstate]
}

resource "yandex_resourcemanager_folder_iam_binding" "ydb_editor" {
  folder_id = var.folder_id
  role      = "ydb.editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.tfstate.id}"
  ]
  depends_on = [yandex_iam_service_account.tfstate]
}

#resource "yandex_resourcemanager_folder_iam_binding" "storage_editor" {
#  folder_id = var.folder_id
#  role      = "storage.editor"
#  members   = [
#    "serviceAccount:${yandex_iam_service_account.tfstate.id}"
#  ]
#  depends_on = [yandex_iam_service_account.tfstate]
#}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "tfstate-static-key" {
  service_account_id = yandex_iam_service_account.tfstate.id
  description        = "Static key for my bucket"
  depends_on = [yandex_iam_service_account.tfstate]
}

# Создание бакета с использованием ключа
resource "yandex_storage_bucket" "tfstate-develop" {
  access_key = yandex_iam_service_account_static_access_key.tfstate-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key
  bucket     = "tfstate-develop-aps"
  max_size   = 1073741824
  folder_id  = var.folder_id
  grant {
    id          = yandex_iam_service_account.tfstate.id
    type        = "CanonicalUser"
    permissions = ["READ", "WRITE"]
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.tfstate-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  #depends_on = [null_resource.add_storage_admin]
}

resource "yandex_kms_symmetric_key" "tfstate-key" {
  name              = "tfstate-key"
  description       = "Key for bucket tfstate develop>"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // 1 year
}


resource "null_resource" "set_token" {
  depends_on = [yandex_iam_service_account.tfstate]
  provisioner "local-exec" {
    command    = "yc config set token ${var.token} && yc config set folder-name default"
    on_failure = continue
  }
}

#resource "null_resource" "add_storage_admin" {
#  depends_on = [null_resource.set_token]
#  provisioner "local-exec" {
#    command    = "yc resource-manager folder add-access-binding ${var.folder_id} --role storage.admin --subject serviceAccount:${yandex_iam_service_account.tfstate.id}"
#    on_failure = continue
#  }
#
#  triggers = {
#    always_run         = timestamp() #всегда т.к. дата и время постоянно изменяются
#  }
#}
#
#resource "null_resource" "del_storage_admin" {
#  depends_on = [yandex_storage_bucket.tfstate-develop]
#  provisioner "local-exec" {
#    command    = "yc resource-manager folder remove-access-binding ${var.folder_id} --role storage.admin --subject serviceAccount:${yandex_iam_service_account.tfstate.id}"
#    on_failure = continue
#  }
#
#  triggers = {
#    always_run         = timestamp() #всегда т.к. дата и время постоянно изменяются
#  }
#}

resource "null_resource" "create_ydb" {
  depends_on = [null_resource.set_token]

  provisioner "local-exec" {
    command = "yc ydb database create tfstate-lock --serverless  --sls-storage-size 1G"
    on_failure = continue
  }

  provisioner "local-exec" {
    when = destroy
    command = "yc ydb database delete tfstate-lock && rm ydb.yaml"
    on_failure = continue
  }

  triggers = {
    always_run         = timestamp() #всегда т.к. дата и время постоянно изменяются
  }
}

data "external" "ydb" {
  program = ["bash", "get_ydb.sh"]
  depends_on = [null_resource.create_ydb]
}
