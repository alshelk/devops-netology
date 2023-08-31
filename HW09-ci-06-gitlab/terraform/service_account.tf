resource "yandex_iam_service_account" "sa" {
  name        = "kuber-robot"
  description = "dynamic account for kuber"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "admin-account-iam" {
  folder_id   = var.folder_id
  role        = "admin"
  member      = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
