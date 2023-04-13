output "s3_access_key" {
  value = yandex_iam_service_account_static_access_key.tfstate-static-key.access_key
  description = "s3 access key"
}

output "s3_secret_key" {
  value = yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key
  description = "s3 secret key"
  sensitive = true
}

#        dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g8dbhansmnljtkt5sb/etnmc1fs0odftcsf9mb1"
        #dynamodb_table = "tflock-develop"
#dynamodb_endpoint=${yamldecode(file("ydb.yaml"))["document_api_endpoint"]}
#${command(yc ydb database get --name tfstate-lock)}

resource "local_file" "backend_tfvars" {
    content     = <<-EOL
bucket=${yandex_storage_bucket.tfstate-develop.bucket}
access_key=${yandex_iam_service_account_static_access_key.tfstate-static-key.access_key}
secret_key=${yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key}
dynamodb_endpoint=${data.external.ydb.result.document_api_endpoint}
EOL

    filename = "${path.module}/backend.tfvars"
}

