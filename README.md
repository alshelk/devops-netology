# devops-netology

Modifed

Будут проигнорированы:

1. **/.terraform/*
	Все файлы во всех вложенных директориях .terraform
2. *.tfstate   *.tfstate.*
 	Все файлы с расширением .tfstate и все файлы содержащие .tfstate. в названии
3. crash.log  crash.*.log
        Все файлы crash.log и вариации содержащие crash. в начале и .log в конце имени файла
4. *.tfvars *.tfvars.json
        Все файлы с расширением .tfvars и .tfvars.json
5. override.tf override.tf.json *_override.tf *_override.tf.json
	Все файлы override.tf и override.tf.json, а также файлы имена которых заканчиваются на  _override.tf _override.tf.json
6. .terraformrc terraform.rc
        Все файлы terraform.rc и файлы с расширением .terraformrc


new line homework 2.2.3

