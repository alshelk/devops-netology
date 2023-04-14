output "s3_access_key" {
  value = yandex_iam_service_account_static_access_key.tfstate-static-key.access_key
  description = "s3 access key"
}

output "s3_secret_key" {
  value = yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key
  description = "s3 secret key"
  sensitive = true
}

resource "local_file" "backend_tfvars" {
    content     = <<-EOL
bucket="${yandex_storage_bucket.tfstate-develop.bucket}"
access_key="${yandex_iam_service_account_static_access_key.tfstate-static-key.access_key}"
secret_key="${yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key}"
dynamodb_endpoint="${data.external.ydb.result.document_api_endpoint}"
dynamodb_table="tflock-develop"
EOL

    filename = "${path.module}/backend.tfvars"
}

#ydb -e grpcs://ydb.serverless.yandexcloud.net:2135 -d /ru-central1/b1g8dbhansmnljtkt5sb/etno5qhldukf1iuaus5c  --yc-token-file token.tfvars yql -s "CREATE TABLE tflock_develop2 (    __Hash Uint64,    LockID Utf8,    __RowData JsonDocument,    PRIMARY KEY (__Hash, LockID))"
#https://ydb.tech/en/docs/reference/ydb-cli/connect