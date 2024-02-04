resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "netology-lesson"

  anonymous_access_flags {
    read = true
    list = false
  }
}

resource "yandex_storage_object" "my_store" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "netology-lesson"
  key    = "picture1.jpeg"
#   acl    = "public-read"
  source = "../images.jpeg"
  tags = {
    test = "value"
  }
  depends_on = [
    yandex_storage_bucket.bucket
  ]
}