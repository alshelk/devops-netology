
# создаем сервесный акаунт
resource "yandex_iam_service_account" "tfstate" {
  name        = "tfstate"
  description = "Account for terraform tfstate"
  folder_id   = var.folder_id
}

# назаначаем права на сервесный аккаунт
resource "yandex_resourcemanager_folder_iam_binding" "storage_editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.tfstate.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "ydb_editor" {
  folder_id = var.folder_id
  role      = "ydb.editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.tfstate.id}"
  ]
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "tfstate-static-key" {
  service_account_id = yandex_iam_service_account.tfstate.id
  description        = "Static key for my bucket"
}

# Создание бакета с использованием ключа
resource "yandex_storage_bucket" "tfstate-develop" {
  access_key = yandex_iam_service_account_static_access_key.tfstate-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key
  bucket     = "tfstate-develop-aps"
  max_size   = 1073741824
#  grant {
#    id          = yandex_iam_service_account.tfstate.id
#    type        = "serviceAccount"
#    permissions = ["READ", "WRITE"]
#  }
}

resource "null_resource" "create_ydb" {
  provisioner "local-exec" {
    command = "yc config set token ${var.token} && yc config set folder-name default"
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "yc ydb database create tfstate-lock --serverless  --sls-storage-size 1G > ydb.yaml"
    on_failure = continue
  }
}
#ydb -e grpcs://ydb.serverless.yandexcloud.net:2135 -d /ru-central1/b1g8dbhansmnljtkt5sb/etno5qhldukf1iuaus5c  --yc-token-file token.tfvars yql -s "CREATE TABLE tflock_develop2 (    __Hash Uint64,    LockID Utf8,    __RowData JsonDocument,    PRIMARY KEY (__Hash, LockID))"