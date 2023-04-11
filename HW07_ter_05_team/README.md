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
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1/hw04$ tflint --init
vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1/hw04$ tflint
4 issue(s) found:

providers.tf:10:1: Warning - Missing version constraint for provider "yandex" in "required_providers" (terraform_required_providers)
variables.tf:36:1: Warning - variable "vms_ssh_root_key" is declared but not used (terraform_unused_declarations)
variables.tf:43:1: Warning - variable "vm_web_name" is declared but not used (terraform_unused_declarations)
variables.tf:50:1: Warning - variable "vm_db_name" is declared but not used (terraform_unused_declarations)

vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1/demonstration1$ tflint --init
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


vagrant@vm1:/netology_data/HW07_ter_05_team/src/ex1$ checkov -d ./
demonstration1/ hw04/           
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
1. предупреждение что в качестве ref используется имя ветки по умолчанию (Warning - Module source "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" uses a default branch as ref (main))  
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
$ terraform init -backend-config=...
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