# Домашнее задание к занятию "Использование Terraform в команде"

------

### Задание 1

1. Возьмите код:
- из [ДЗ к лекции №04](https://github.com/netology-code/ter-homeworks/tree/main/04/src) 
- из [демо к лекции №04](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1).
2. Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.
3. Перечислите какие **типы** ошибок обнаружены в проекте (без дублей).

#### Решение

2.

tflint:

```bash
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1/hw04$ tflint
4 issue(s) found:

providers.tf:10:1: Warning - Missing version constraint for provider "yandex" in "required_providers" (terraform_required_providers)
variables.tf:36:1: Warning - variable "vms_ssh_root_key" is declared but not used (terraform_unused_declarations)
variables.tf:43:1: Warning - variable "vm_web_name" is declared but not used (terraform_unused_declarations)
variables.tf:50:1: Warning - variable "vm_db_name" is declared but not used (terraform_unused_declarations)

vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1/demonstration1$ tflint 
6 issue(s) found:

main.tf:33:21: Warning - Module source "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" uses a default branch as ref (main) (terraform_module_pinned_source)
main.tf:25:1: Warning - Missing version constraint for provider "yandex" in "required_providers" (terraform_required_providers)
main.tf:51:1: Warning - Missing version constraint for provider "template" in "required_providers" (terraform_required_providers)
variables.tf:22:1: Warning - variable "default_cidr" is declared but not used (terraform_unused_declarations)
variables.tf:28:1: Warning - variable "vpc_name" is declared but not used (terraform_unused_declarations)
variables.tf:34:1: Warning - variable "public_key" is declared but not used (terraform_unused_declarations)

```
checkov

```bash
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1$ checkov -d ./hw04/
[ terraform framework ]: 100%|████████████████████|[3/3], Current File Scanned=variables.tf
[ secrets framework ]: 100%|████████████████████|[4/4], Current File Scanned=./hw04/main.tf     

       _               _              
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V / 
  \___|_| |_|\___|\___|_|\_\___/ \_/  
                                      
By bridgecrew.io | version: 2.3.158 

       
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1$ checkov -d ./demonstration1/
[ kubernetes framework ]: 100%|████████████████████|[1/1], Current File Scanned=cloud-init.yml
2023-04-11 13:45:13,882 [MainThread  ] [WARNI]  Failed to download module git::https://github.com/udjin10/yandex_compute_instance.git?ref=main:None (for external modules, the --download-external-modules flag is required)
[ ansible framework ]: 100%|████████████████████|[1/1], Current File Scanned=cloud-init.yml
[ terraform framework ]: 100%|████████████████████|[2/2], Current File Scanned=variables.tf
[ secrets framework ]: 100%|████████████████████|[3/3], Current File Scanned=./demonstration1/cloud-init.yml

       _               _              
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V / 
  \___|_| |_|\___|\___|_|\_\___/ \_/  
                                      
By bridgecrew.io | version: 2.3.158 

```

3. 

в [ДЗ к лекции №04](https://github.com/netology-code/ter-homeworks/tree/main/04/src)

```text
1. не указана версия провайдера (Warning - Missing version constraint for provider )
2. объявлены переменные (vms_ssh_root_key, vm_web_name, vm_db_name), но не используются (Warning - variable "vms_ssh_root_key" is declared but not used)

```

в [демо к лекции №04](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1)

```text
1. предупреждение, что используется ссылка на репозиторий git без привязки к версии (Warning - Module source "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" uses a default branch as ref (main))  
2. те же предупреждения что не указана версия провайдера 
3. и есть переменные которые объявлены, но не используются
```

------

### Задание 2

1. Возьмите ваш GitHub репозиторий с **выполненным ДЗ №4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'
2. Повторите демонстрацию лекции: настройте YDB, S3 bucket, yandex service account, права доступа и мигрируйте State проекта в S3 с блокировками.
3. Закомитьте в ветку 'terraform-05' все изменения.
4. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
5. Пришлите ответ об ошибке доступа к State.
6. Принудительно разблокируйте State. Пришлите команду и вывод.

#### Решение

Мигрируем State в S3:

```bash
$ terraform init -backend-config=../bucket/backend.tfvars
Initializing modules...

Initializing the backend...
Acquiring state lock. This may take a few moments...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/template from the dependency lock file
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Reusing previous version of hashicorp/null from the dependency lock file
- Using previously-installed hashicorp/template v2.2.0
- Using previously-installed yandex-cloud/yandex v0.89.0
- Using previously-installed hashicorp/null v3.2.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

Ошибка доступа:

```bash
$ terraform apply
╷
│ Error: Error acquiring the state lock
│ 
│ Error message: ConditionalCheckFailedException: Condition not satisfied
│ Lock Info:
│   ID:        f7e8d127-a145-f5d2-5641-12ee1fe1cca0
│   Path:      tfstate-develop-aps/terraform.tfstate
│   Operation: OperationTypeInvalid
│   Who:       vagrant@vm1
│   Version:   1.3.7
│   Created:   2023-04-11 12:09:00.019206084 +0000 UTC
│   Info:      
│ 
│ 
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue above and try
│ again. For most commands, you can disable locking with the "-lock=false"
│ flag, but this is not recommended.

```

Принудительная разблокировка:

```bash
$ terraform force-unlock f7e8d127-a145-f5d2-5641-12ee1fe1cca0
Do you really want to force-unlock?
  Terraform will remove the lock on the remote state.
  This will allow local Terraform commands to modify this state, even though it
  may still be in use. Only 'yes' will be accepted to confirm.

  Enter a value: yes

Terraform state has been successfully unlocked!

The state has been unlocked, and Terraform commands should now be able to
obtain a new lock on the remote state.

```


------
### Задание 3  

1. Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.
2. Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте комит.
3. Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'. 
4. Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.
5. Пришлите ссылку на PR для ревью(вливать код в 'terraform-05' не нужно).

### Решение 

2.

```bash
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/hw_terraform$ tflint
7 issue(s) found:

Warning: Module source "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" uses a default branch as ref (main) (terraform_module_pinned_source)

  on main.tf line 10:
  10:   source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_module_pinned_source.md

Warning: Missing version constraint for provider "template" in "required_providers" (terraform_required_providers)

  on main.tf line 27:
  27: data "template_file" "cloudinit" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

Warning: Missing version constraint for provider "null" in "required_providers" (terraform_required_providers)

  on null_resource.tf line 1:
   1: resource "null_resource" "web_hosts_provision" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

Warning: Interpolation-only expressions are deprecated in Terraform v0.12.14 (terraform_deprecated_interpolation)

  on null_resource.tf line 8:
   8:     private_key = "${file("~/.ssh/id_rsa")}"

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_deprecated_interpolation.md

Warning: Interpolation-only expressions are deprecated in Terraform v0.12.14 (terraform_deprecated_interpolation)

  on null_resource.tf line 20:
  20:       playbook_src_hash  = "${file("${abspath(path.module)}/cloud-init.yml")}" # при изменении содержимого playbook файла

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_deprecated_interpolation.md

Warning: Interpolation-only expressions are deprecated in Terraform v0.12.14 (terraform_deprecated_interpolation)

  on null_resource.tf line 21:
  21:       ssh_public_key     = "${file("~/.ssh/id_rsa.pub")}" # при изменении переменной

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_deprecated_interpolation.md

Warning: Missing version constraint for provider "yandex" in "required_providers" (terraform_required_providers)

  on providers.tf line 22:
  22: provider "yandex" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/hw_terraform$ tflint
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/hw_terraform$ terraform plan
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=ebfe5cca7da31de38fd95bb03c6532df96c4c1d0c96bcf6b391471536f7e6b67]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc_dev.yandex_vpc_network.new_vpc: Refreshing state... [id=enpucrqk1kj3c3nmg400]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd80f8mhk83hmvp10vh2]
module.vpc_dev.yandex_vpc_subnet.new_subnet: Refreshing state... [id=e9b8bvk96vnjnlmtcj65]
module.test-vm.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmh9u73iop5e9rgho58]
null_resource.web_hosts_provision: Refreshing state... [id=8428585776292310206]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.web_hosts_provision must be replaced
-/+ resource "null_resource" "web_hosts_provision" {
      ~ id       = "8428585776292310206" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "always_run"        = "2023-04-14T12:17:02Z" -> (known after apply)
            # (2 unchanged elements hidden)
        }
    }

Plan: 1 to add, 0 to change, 1 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
Releasing state lock. This may take a few moments...


```

```bash
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/bucket$ tflint
11 issue(s) found:

Warning: Interpolation-only expressions are deprecated in Terraform v0.12.14 (terraform_deprecated_interpolation)

  on main.tf line 81:
  81:     always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_deprecated_interpolation.md

Warning: Interpolation-only expressions are deprecated in Terraform v0.12.14 (terraform_deprecated_interpolation)

  on main.tf line 93:
  93:     always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_deprecated_interpolation.md

Warning: Missing version constraint for provider "null" in "required_providers" (terraform_required_providers)

  on main.tf line 97:
  97: resource "null_resource" "create_ydb" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

Warning: Interpolation-only expressions are deprecated in Terraform v0.12.14 (terraform_deprecated_interpolation)

  on main.tf line 112:
 112:     always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_deprecated_interpolation.md

Warning: Missing version constraint for provider "external" in "required_providers" (terraform_required_providers)

  on main.tf line 116:
 116: data "external" "ydb" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

Warning: Missing version constraint for provider "local" in "required_providers" (terraform_required_providers)

  on outputs.tf line 12:
  12: resource "local_file" "backend_tfvars" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

Warning: Missing version constraint for provider "yandex" in "required_providers" (terraform_required_providers)

  on providers.tf line 21:
  21: provider "yandex" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

Warning: variable "default_cidr" is declared but not used (terraform_unused_declarations)

  on variables.tf line 22:
  22: variable "default_cidr" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_unused_declarations.md

Warning: variable "vpc_name" is declared but not used (terraform_unused_declarations)

  on variables.tf line 28:
  28: variable "vpc_name" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_unused_declarations.md

Warning: variable "public_key" is declared but not used (terraform_unused_declarations)

  on variables.tf line 34:
  34: variable "public_key" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_unused_declarations.md

Warning: variable "username" is declared but not used (terraform_unused_declarations)

  on variables.tf line 39:
  39: variable "username" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_unused_declarations.md

```

checkov

```bash
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/hw_terraform$ checkov -d ./
[ kubernetes framework ]: 100%|████████████████████|[2/2], Current File Scanned=cloud-init.yml
2023-04-14 11:28:29,997 [MainThread  ] [WARNI]  Failed to download module git::https://github.com/udjin10/yandex_compute_instance.git?ref=main:None (for external modules, the --download-external-modules flag is required)
[ ansible framework ]: 100%|████████████████████|[2/2], Current File Scanned=cloud-init.yml
[ terraform framework ]: 100%|████████████████████|[8/8], Current File Scanned=../modules/vpc/variables.tf([{/netology_data/HW07_ter_05_team/src/ex2/hw_terraform/main.tf#*#0}])
[ secrets framework ]: 100%|████████████████████|[7/7], Current File Scanned=./cloud-init.yml  


       _               _              
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V / 
  \___|_| |_|\___|\___|_|\_\___/ \_/  
                                      
By bridgecrew.io | version: 2.3.158 
Update available 2.3.158 -> 2.3.165
Run pip3 install -U checkov to update 



More details: https://www.bridgecrew.cloud/projects?repository=home8061_cli_repo/hw_terraform&branch=bc-0ca6c09_master&repoUUID=fa8cc59c-6c68-402e-b174-a44fceef1971&runId=latest&viewId=CICDRuns

```

```bash
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/bucket$ checkov -d ./
[ terraform framework ]:   0%|                    |[0/4], Current File Scanned=main.tf2023-04-14 12:07:48,154 [MainThread  ] [ERROR]  Failed to run check CKV_YC_17 on /main.tf:yandex_storage_bucket.tfstate-develop
Traceback (most recent call last):
  File "/home/vagrant/.local/lib/python3.8/site-packages/checkov/common/checks/base_check.py", line 73, in run
    check_result["result"] = self.scan_entity_conf(entity_configuration, entity_type)
  File "/home/vagrant/.local/lib/python3.8/site-packages/checkov/terraform/checks/resource/base_resource_check.py", line 43, in scan_entity_conf
    return self.scan_resource_conf(conf)
  File "/home/vagrant/.local/lib/python3.8/site-packages/checkov/terraform/checks/resource/yandexcloud/ObjectStorageBucketPublicAccess.py", line 28, in scan_resource_conf
    grant_uri_block = conf["grant"][0]["uri"]
KeyError: 'uri'
[ terraform framework ]: 100%|████████████████████|[4/4], Current File Scanned=variables.tf
[ secrets framework ]: 100%|████████████████████|[5/5], Current File Scanned=./main.tf     


       _               _              
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V / 
  \___|_| |_|\___|\___|_|\_\___/ \_/  
                                      
By bridgecrew.io | version: 2.3.158 
Update available 2.3.158 -> 2.3.165
Run pip3 install -U checkov to update 


terraform scan results:

Passed checks: 4, Failed checks: 1, Skipped checks: 0

Check: CKV_YC_24: "Ensure passport account is not used for assignment. Use service accounts and federated accounts where possible."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.storage_admin
	File: /main.tf:10-17
Check: CKV_YC_23: "Ensure folder member does not have elevated access."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.storage_admin
	File: /main.tf:10-17
Check: CKV_YC_24: "Ensure passport account is not used for assignment. Use service accounts and federated accounts where possible."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.storage_editor
	File: /main.tf:28-35
Check: CKV_YC_23: "Ensure folder member does not have elevated access."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.storage_editor
	File: /main.tf:28-35
Check: CKV_YC_3: "Ensure storage bucket is encrypted."
	FAILED for resource: yandex_storage_bucket.tfstate-develop
	File: /main.tf:45-60

		45 | resource "yandex_storage_bucket" "tfstate-develop" {
		46 |   access_key = yandex_iam_service_account_static_access_key.tfstate-static-key.access_key
		47 |   secret_key = yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key
		48 |   bucket     = "tfstate-develop-aps"
		49 |   max_size   = 1073741824
		50 |   folder_id  = var.folder_id
		51 |   grant {
		52 |     id          = yandex_iam_service_account.tfstate.id
		53 |     type        = "CanonicalUser"
		54 |     permissions = ["READ", "WRITE"]
		55 |   }
		56 | 
		57 | 
		58 | 
		59 |   #depends_on = [null_resource.add_storage_admin]
		60 | }


More details: https://www.bridgecrew.cloud/projects?repository=home8061_cli_repo/bucket&branch=bc-a237d35_master&repoUUID=3c7af5c0-0bda-4a22-a300-a5718a255fc8&runId=latest&viewId=CICDRuns

vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/bucket$ terraform plan
yandex_iam_service_account.tfstate: Refreshing state... [id=ajeqmffjhc97bspgvujr]
yandex_resourcemanager_folder_iam_binding.storage_admin: Refreshing state... [id=b1gs8f7ibom6nv7b1qnd/storage.admin]
null_resource.set_token: Refreshing state... [id=1445591791548286398]
yandex_iam_service_account_static_access_key.tfstate-static-key: Refreshing state... [id=aje483v91odit25l8soj]
yandex_resourcemanager_folder_iam_binding.storage_editor: Refreshing state... [id=b1gs8f7ibom6nv7b1qnd/storage.editor]
null_resource.create_ydb: Refreshing state... [id=7949782260569679621]
yandex_storage_bucket.tfstate-develop: Refreshing state... [id=tfstate-develop-aps]
local_file.backend_tfvars: Refreshing state... [id=d3dbc80e3527b8dd98924c53fc4f307865bad2c9]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place
-/+ destroy and then create replacement
 <= read (data resources)

Terraform will perform the following actions:

  # data.external.ydb will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "external" "ydb" {
      + id      = (known after apply)
      + program = [
          + "bash",
          + "get_ydb.sh",
        ]
      + result  = (known after apply)
    }

  # local_file.backend_tfvars must be replaced
-/+ resource "local_file" "backend_tfvars" {
      ~ content              = (sensitive value) -> (sensitive value) # forces replacement
      ~ content_base64sha256 = "qms6V4ARVqq3UwEdmvo9YBJio7kjbMxpidCo9y51bEg=" -> (known after apply)
      ~ content_base64sha512 = "8THVAaka3kgJj4jtXkXJ+V9h49jQmE1XXo0Yj5O6Ggd2BbmMTcVQ0N89nRIAiPmITEfJoiKIWcSLzJiGdM26tA==" -> (known after apply)
      ~ content_md5          = "ccc8e430f24a2efa02a8fbbe1a8b025e" -> (known after apply)
      ~ content_sha1         = "d3dbc80e3527b8dd98924c53fc4f307865bad2c9" -> (known after apply)
      ~ content_sha256       = "aa6b3a57801156aab753011d9afa3d601262a3b9236ccc6989d0a8f72e756c48" -> (known after apply)
      ~ content_sha512       = "f131d501a91ade48098f88ed5e45c9f95f61e3d8d0984d575e8d188f93ba1a077605b98c4dc550d0df3d9d120088f9884c47c9a2228859c48bcc988674cdbab4" -> (known after apply)
      ~ id                   = "d3dbc80e3527b8dd98924c53fc4f307865bad2c9" -> (known after apply)
        # (3 unchanged attributes hidden)
    }

  # null_resource.create_ydb must be replaced
-/+ resource "null_resource" "create_ydb" {
      ~ id       = "7949782260569679621" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "always_run" = "2023-04-14T12:05:55Z" -> (known after apply)
        }
    }

  # yandex_kms_symmetric_key.tfstate-key will be created
  + resource "yandex_kms_symmetric_key" "tfstate-key" {
      + created_at        = (known after apply)
      + default_algorithm = "AES_128"
      + description       = "Key for bucket tfstate develop>"
      + folder_id         = (known after apply)
      + id                = (known after apply)
      + name              = "tfstate-key"
      + rotated_at        = (known after apply)
      + rotation_period   = "8760h"
      + status            = (known after apply)
    }

  # yandex_storage_bucket.tfstate-develop will be updated in-place
  ~ resource "yandex_storage_bucket" "tfstate-develop" {
        id                    = "tfstate-develop-aps"
        # (9 unchanged attributes hidden)

      + server_side_encryption_configuration {
          + rule {
              + apply_server_side_encryption_by_default {
                  + kms_master_key_id = (known after apply)
                  + sse_algorithm     = "aws:kms"
                }
            }
        }

        # (3 unchanged blocks hidden)
    }

Plan: 3 to add, 1 to change, 2 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```

После исправления ошибок:

```bash
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/hw_terraform$ tflint
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex2/hw_terraform$ checkov -d ./
[ kubernetes framework ]: 100%|████████████████████|[2/2], Current File Scanned=cloud-init.yml
2023-04-11 15:39:59,903 [MainThread  ] [WARNI]  Failed to download module git::https://github.com/udjin10/yandex_compute_instance.git?ref=main:None (for external modules, the --download-external-modules flag is required)
[ ansible framework ]: 100%|████████████████████|[2/2], Current File Scanned=cloud-init.yml
[ terraform framework ]: 100%|████████████████████|[9/9], Current File Scanned=../modules/vpc/variables.tf([{/netology_data/HW07_ter_05_team/src/ex2/hw_terraform/main.tf#*#0}])
[ secrets framework ]: 100%|████████████████████|[8/8], Current File Scanned=./cloud-init.yml  


       _               _              
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V / 
  \___|_| |_|\___|\___|_|\_\___/ \_/  
                                      
By bridgecrew.io | version: 2.3.158 
Update available 2.3.158 -> 2.3.160
Run pip3 install -U checkov to update 


terraform scan results:

Passed checks: 7, Failed checks: 0, Skipped checks: 0

Check: CKV_YC_24: "Ensure passport account is not used for assignment. Use service accounts and federated accounts where possible."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.storage_editor
	File: /backend.tf:9-15
Check: CKV_YC_23: "Ensure folder member does not have elevated access."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.storage_editor
	File: /backend.tf:9-15
Check: CKV_YC_24: "Ensure passport account is not used for assignment. Use service accounts and federated accounts where possible."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.ydb_editor
	File: /backend.tf:17-23
Check: CKV_YC_23: "Ensure folder member does not have elevated access."
	PASSED for resource: yandex_resourcemanager_folder_iam_binding.ydb_editor
	File: /backend.tf:17-23
Check: CKV_YC_9: "Ensure KMS symmetric key is rotated."
	PASSED for resource: yandex_kms_symmetric_key.key-a
	File: /backend.tf:31-36
Check: CKV_YC_3: "Ensure storage bucket is encrypted."
	PASSED for resource: yandex_storage_bucket.tfstate-develop
	File: /backend.tf:39-57
Check: CKV_YC_17: "Ensure storage bucket does not have public access permissions."
	PASSED for resource: yandex_storage_bucket.tfstate-develop
	File: /backend.tf:39-57


```



## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 4*  

1. Напишите переменные с валидацией:
- type=string, description="ip-адрес", проверка что ip-адрес валидный
- type=list(string), description="список ip-адресов", проверка что все валидны
- type=string, description="любая строка", проверка что строка не содержит в себе символов верхнего регистра
- type=object, проверка что введено только одно из опциональных значений по примеру:
```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}
```

### Задание 5**  

1. Настройте любую известную вам CI/CD или замените ее самописным bash/python скриптом.
2. Скачайте с ее помощью ваш репозиторий с кодом и инициализируйте инфраструктуру.