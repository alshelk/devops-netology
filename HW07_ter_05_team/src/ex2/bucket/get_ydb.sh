#!/usr/bin/env bash

echo -n "{\"document_api_endpoint\":$(yc ydb database get --name tfstate-lock | awk '/^document_api_endpoint/ {printf "\"%s\"", $2}')}"