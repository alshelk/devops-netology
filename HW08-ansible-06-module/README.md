# Домашнее задание к занятию 6 «Создание собственных модулей»

## Подготовка к выполнению

1. Создайте пустой публичный репозиторий в своём любом проекте: `my_own_collection`.
2. Скачайте репозиторий Ansible: `git clone https://github.com/ansible/ansible.git` по любому, удобному вам пути.
3. Зайдите в директорию Ansible: `cd ansible`.
4. Создайте виртуальное окружение: `python3 -m venv venv`.
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении.
6. Установите зависимости `pip install -r requirements.txt`.
7. Запустите настройку окружения `. hacking/env-setup`.
8. Если все шаги прошли успешно — выйдите из виртуального окружения `deactivate`.
9. Ваше окружение настроено. Чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`.

<details>
<summary>

</summary>

```bash
$ . venv/bin/activate && . hacking/env-setup
running egg_info
creating lib/ansible_core.egg-info
writing lib/ansible_core.egg-info/PKG-INFO
writing dependency_links to lib/ansible_core.egg-info/dependency_links.txt
writing entry points to lib/ansible_core.egg-info/entry_points.txt
writing requirements to lib/ansible_core.egg-info/requires.txt
writing top-level names to lib/ansible_core.egg-info/top_level.txt
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
warning: no files found matching 'changelogs/CHANGELOG*.rst'
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'

Setting up Ansible to run out of checkout...

PATH=/netology_data/HW08-ansible-06-module/ansible/bin:/netology_data/HW08-ansible-06-module/ansible/venv/bin:/home/vagrant/.local/bin:/home/vagrant/yandex-cloud/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
PYTHONPATH=/netology_data/HW08-ansible-06-module/ansible/test/lib:/netology_data/HW08-ansible-06-module/ansible/lib:/netology_data/HW08-ansible-06-module/ansible/test/lib:/netology_data/HW08-ansible-06-module/ansible/lib
MANPATH=/netology_data/HW08-ansible-06-module/ansible/docs/man:/usr/local/man:/usr/local/share/man:/usr/share/man

Remember, you may wish to specify your host file with -i

Done!

```
</details>

## Основная часть

Ваша цель — написать собственный module, который вы можете использовать в своей role через playbook. Всё это должно быть собрано в виде collection и отправлено в ваш репозиторий.

**Шаг 1.** В виртуальном окружении создайте новый `my_own_module.py` файл.

**Шаг 2.** Наполните его содержимым:

```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True),
        new=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['name']
    result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if module.params['new']:
        result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
Или возьмите это наполнение [из статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

**Шаг 3.** Заполните файл в соответствии с требованиями Ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.

<details>
<summary>

</summary>


```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_own_module

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    path:
        description: This is the path to file.txt.
        required: true
        type: str
    content:
        description: Text fot file.txt
        required: false
        type: str
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Alexey (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Create file.txt
- name: Create file
  my_namespace.my_collection.my_test:
    path: "./new_folder/"
    content: test content

'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The message about file creation and its contents
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

import os
from ansible.module_utils.basic import AnsibleModule

def create_file(path, content):
    if not os.path.lexists(path):
        os.makedirs(path)
    if os.path.lexists(path+'file.txt'):
        return "exsist"
    else:
        try:
            with open(path+'file.txt', 'w') as fp:
                fp.write(content)
        except:
            raise
        return "created"

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=False, default='default text')
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    path = module.params['path']
    content = module.params['content']

    res = create_file(path, content)

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)


    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if res == "created":
        result['original_message'] = 'file.txt created to path: {} with content: {}'.format(module.params['path'], module.params['content'])
        result['message'] = 'goodbye'
        result['changed'] = True


    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()

```

</details>

**Шаг 4.** Проверьте module на исполняемость локально.

<details>
<summary>

</summary>

```bash
(venv) vagrant@vm1:/netology_data/HW08-ansible-06-module/ansible$ python3 -m ansible.modules.my_own_module ../payload.json 

{"changed": true, "original_message": "file.txt created to path: ./testfolder/ with content: my test content", "message": "goodbye", "invocation": {"module_args": {"path": "./testfolder/", "content": "my test content"}}}
```

```bash
(venv) vagrant@vm1:/netology_data/HW08-ansible-06-module/ansible$ ansible localhost -m my_own_module -a "path=./testfolder2/ content=test2"
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the
Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any
point.
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | CHANGED => {
    "changed": true,
    "message": "goodbye",
    "original_message": "file.txt created to path: ./testfolder2/ with content: test2"
}

```

</details>

**Шаг 5.** Напишите single task playbook и используйте module в нём.

<details>
<summary>

</summary>

```yaml
---
- name: Test module
  hosts: localhost
  tasks:
    - name: Call my_own_module
      my_own_module:
        path: "./testfolder/"
        content: "test module content"

```

```bash
(venv) vagrant@vm1:/netology_data/HW08-ansible-06-module/ansible$ ansible-playbook -v site.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the
Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any
point.
No config file found; using defaults
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] ********************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]

TASK [Call my_own_module] *************************************************************************************************************
changed: [localhost] => {"changed": true, "message": "content: test module content", "original_message": "file.txt created to path: ./testfolder/", "test": "created"}

PLAY RECAP ****************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

</details>

**Шаг 6.** Проверьте через playbook на идемпотентность.

<details>
<summary>

</summary>

```bash
(venv) vagrant@vm1:/netology_data/HW08-ansible-06-module/ansible$ ansible-playbook -v site.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the
Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any
point.
No config file found; using defaults
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] ********************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]

TASK [Call my_own_module] *************************************************************************************************************
ok: [localhost] => {"changed": false, "message": "", "original_message": "", "test": "exsist"}

PLAY RECAP ****************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

</details>


**Шаг 7.** Выйдите из виртуального окружения.

**Шаг 8.** Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`.

<details>
<summary>

</summary>

```bash
vagrant@vm1:/netology_data/HW08-ansible-06-module$ ansible-galaxy collection init my_own_collection.yandex_cloud_elk
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the
Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any
point.
- Collection my_own_collection.yandex_cloud_elk was created successfully


```

</details>

**Шаг 9.** В эту collection перенесите свой module в соответствующую директорию.

**Шаг 10.** Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module.

<details>
<summary>

</summary>

```bash
vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk$ cat roles/createfile-role/defaults/main.yml 
---
path: "./testfolder/"
content: "test module content"

vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk$ cat roles/createfile-role/tasks/main.yml 
---
- name: Call my_own_module
  my_own_collection.yandex_cloud_elk.my_own_module:
    path: "{{ path }}"
    content: "{{ content }}"  

```

</details>

**Шаг 11.** Создайте playbook для использования этой role.

<details>
<summary>

</summary>

```yaml
---
- name: Test module role
  hosts: localhost
  collections:
    - my_own_collection.yandex_cloud_elk
  tasks:
    - name: import role
      ansible.builtin.import_role:
        name: createfile-role
```

</details>

**Шаг 12.** Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.

<details>
<summary>

</summary>

https://github.com/alshelk/my_own_collection/tree/1.0.0

</details>

**Шаг 13.** Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.


<details>
<summary>

</summary>

```bash
vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk$ ansible-galaxy collection build
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the
Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any
point.
Created collection for my_own_collection.yandex_cloud_elk at /netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk/my_own_collection-yandex_cloud_elk-1.0.0.tar.gz

```

</details>

**Шаг 14.** Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.

<details>
<summary>

</summary>

[arhive](https://github.com/alshelk/my_own_collection/tree/0bcbe496339dcd40cbb926bd15610c0c1cffa8d6/arhive)

</details>

**Шаг 15.** Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`.

<details>
<summary>

</summary>

```bash
vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk/arhive$ ansible-galaxy collection install my_own_collection-yandex_cloud_elk-1.0.0.tar.gz 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the
Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any
point.
Starting galaxy collection install process
[WARNING]: Collection cisco.iosxr does not support Ansible version 2.16.0.dev0
[WARNING]: Collection openvswitch.openvswitch does not support Ansible version 2.16.0.dev0
[WARNING]: Collection cisco.nxos does not support Ansible version 2.16.0.dev0
[WARNING]: Collection junipernetworks.junos does not support Ansible version 2.16.0.dev0
[WARNING]: Collection splunk.es does not support Ansible version 2.16.0.dev0
[WARNING]: Collection vyos.vyos does not support Ansible version 2.16.0.dev0
[WARNING]: Collection cisco.asa does not support Ansible version 2.16.0.dev0
[WARNING]: Collection ibm.qradar does not support Ansible version 2.16.0.dev0
[WARNING]: Collection ansible.netcommon does not support Ansible version 2.16.0.dev0
[WARNING]: Collection ansible.posix does not support Ansible version 2.16.0.dev0
[WARNING]: Collection frr.frr does not support Ansible version 2.16.0.dev0
Process install dependency map
Starting collection install process
Installing 'my_own_collection.yandex_cloud_elk:1.0.0' to '/home/vagrant/.ansible/collections/ansible_collections/my_own_collection/yandex_cloud_elk'
my_own_collection.yandex_cloud_elk:1.0.0 was installed successfully
```

</details>

**Шаг 16.** Запустите playbook, убедитесь, что он работает.

<details>
<summary>

</summary>

```bash
vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk/arhive$ cat playbook.yml 
---
- name: Test module role
  hosts: localhost
  collections:
    - my_own_collection.yandex_cloud_elk
  tasks:
    - name: import role
      ansible.builtin.import_role:
        name: createfile-role

vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk/arhive$ ansible-playbook -v playbook.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the
Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any
point.
No config file found; using defaults
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module role] ***************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]

TASK [my_own_collection.yandex_cloud_elk.createfile-role : Call my_own_module] ********************************************************
changed: [localhost] => {"changed": true, "message": "content: test module content", "original_message": "file.txt created to path: ./testfolder/", "test": "created"}

PLAY RECAP ****************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

</details>

**Шаг 17.** В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.

<details>
<summary>
Ответ:
</summary>

[my_own_collection](https://github.com/alshelk/my_own_collection/tree/main)

[my_own_collection-yandex_cloud_elk-1.0.0.tar.gz](https://github.com/alshelk/my_own_collection/blob/main/arhive/my_own_collection-yandex_cloud_elk-1.0.0.tar.gz)

**пункт 4:**

![img.png](img.png)

**пункт 5:**

![img_1.png](img_1.png)

**пункт 15:**

![img_2.png](img_2.png)

**пункт 16:**

![img_3.png](img_3.png)

</details>

## Необязательная часть

1. Реализуйте свой модуль для создания хостов в Yandex Cloud.
2. Модуль может и должен иметь зависимость от `yc`, основной функционал: создание ВМ с нужным сайзингом на основе нужной ОС. Дополнительные модули по созданию кластеров ClickHouse, MySQL и прочего реализовывать не надо, достаточно простейшего создания ВМ.
3. Модуль может формировать динамическое inventory, но эта часть не является обязательной, достаточно, чтобы он делал хосты с указанной спецификацией в YAML.
4. Протестируйте модуль на идемпотентность, исполнимость. При успехе добавьте этот модуль в свою коллекцию.
5. Измените playbook так, чтобы он умел создавать инфраструктуру под inventory, а после устанавливал весь ваш стек Observability на нужные хосты и настраивал его.
6. В итоге ваша коллекция обязательно должна содержать: clickhouse-role (если есть своя), lighthouse-role, vector-role, два модуля: my_own_module и модуль управления Yandex Cloud хостами и playbook, который демонстрирует создание Observability стека.

<details>
<summary>

**Ответ:**

</summary>

<details>
<summary>
module:
</summary>

```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

import os, subprocess, json
from ansible.module_utils.basic import AnsibleModule


def check_dependency(method):
    if method == "cli":
        try:
            res = subprocess.run(["yc", "-v"], stdout=subprocess.PIPE, text=True).stdout
            return res
        except FileNotFoundError:
            os.system("curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash")
            res = check_dependency("cli")
            return "Installed: " + res
    if method == "rest":
        return 1


def yc_auth(method, token):
    if method == "cli":
        res = subprocess.run(["yc", "config", "set", "token", token], stdout=subprocess.PIPE, text=True).stdout
        if res == "":
            return "token set"
        else:
            return res
    if method == "rest":
        return 1

def create_vpc_network(method, folder_id, networkname, netdesc):
    if method == "cli":
        res = subprocess.run(["yc", "vpc", "network", "create", "--name", networkname, "--description", netdesc,
                             "--folder-id", folder_id], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True).stdout
        return res
    if method == "rest":
        return 1

def get_fact(method, in_cmd, fname, ftype):
    if method == "cli":
        resout = subprocess.run(in_cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True).stdout
        for net in json.loads(resout):
            if net["name"] == fname:
                rid = net[ftype]
        return rid

def create_vpc_subnet(method, subnetname, subdesc, network_id, zone, cidr, folder_id):
    if method == "cli":
        res = subprocess.run(["yc", "vpc", "subnet", "create", "--name", subnetname, "--description", subdesc,
                              "--network-id", network_id, "--zone", zone, "--range", cidr, "--folder-id", folder_id], stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT, text=True).stdout
        return res
    if method == "rest":
        return 1

def create_vm_instance(method, vm_name, zone, subnetname, imgfamily, disksize, ram, cores, frac, pathkey, folder_id):
    if method == "cli":
        res = subprocess.run(["yc", "compute", "instance", "create", "--name", vm_name, "--zone", zone,
                              "--network-interface", "subnet-name={},nat-ip-version=ipv4".format(subnetname),
                              "--create-boot-disk", "image-folder-id=standard-images,image-family={},size={}".format(imgfamily, disksize),
                              "--memory", ram, "--cores", cores, "--core-fraction", frac,
                              "--ssh-key", pathkey, "--folder-id", folder_id], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True).stdout
        return res

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        step=dict(type='str', required=True),
        folder_id=dict(type='str', required=False, default=""),
        token=dict(type='str', required=False, default=""),
        cloud_id=dict(type='str', required=False, default=""),
        vm_name=dict(type='str', required=False, default="vm1"),
        method=dict(type='str', required=False, default="cli"),
        networkname=dict(type='str', required=False, default="learning"),
        subnetname=dict(type='str', required=False, default="learning-subnet"),
        subdesc=dict(type='str', required=False, default="learning subnetwork"),
        netdesc=dict(type='str', required=False, default="learning network"),
        zone=dict(type='str', required=False, default="ru-central1-a"),
        cidr=dict(type='str', required=False, default="10.0.1.0/24"),
        imgfamily=dict(type='str', required=False, default="centos-7"),
        disksize=dict(type='str', required=False, default="20GB"),
        ram=dict(type='str', required=False, default="2GB"),
        cores=dict(type='str', required=False, default="2"),
        frac=dict(type='str', required=False, default="20"),
        pathkey=dict(type='str', required=False, default="/home/vagrant/.ssh/id_rsa.pub")

    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # for python 3.9
    if  module.params['step'] == "auth":
            res = check_dependency(module.params['method'])
            auth = yc_auth(module.params['method'], module.params['token'])
            result['message'] = '['+res+', '+auth+']'
            if "Installed" in res:
                result['changed'] = True
    elif module.params['step'] == "network":
            netname = create_vpc_network(module.params['method'], module.params['folder_id'],
                                         module.params['networkname'],  module.params['netdesc'])
            result['message'] = netname
            if not "AlreadyExists" in netname:
                result['changed'] = True
    elif module.params['step'] == "subnetwork":
            network_id = get_fact(module.params['method'],
                                "yc vpc network list --folder-id {} --format json".format(module.params['folder_id']),
                                module.params['networkname'], "id")

            subnet = create_vpc_subnet(module.params['method'], module.params['subnetname'], module.params['subdesc'],
                                       network_id, module.params['zone'], module.params['cidr'], module.params['folder_id'])

            result['message'] = subnet
            if not "ERROR" in subnet:
                result['changed'] = True
    elif module.params['step'] == "vm":
            vm = create_vm_instance(module.params['method'], module.params['vm_name'], module.params['zone'],
                                    module.params['subnetname'], module.params['imgfamily'], module.params['disksize'],
                                    module.params['ram'], module.params['cores'], module.params['frac'],
                                    module.params['pathkey'], module.params['folder_id'])

            vm_ip = get_fact(module.params['method'],
                                  "yc compute instance list --folder-id {} --format json".format(module.params['folder_id']),
                                  module.params['vm_name'], "network_interfaces")

            result['message'] = vm_ip
            if not "AlreadyExists" in vm:
                result['changed'] = True

    # match module.params['step']:
    #     case "auth":
    #         res = check_dependency(module.params['method'])
    #         auth = yc_auth(module.params['method'], module.params['token'])
    #         result['message'] = '['+res+', '+auth+']'
    #         if "Installed" in res:
    #             result['changed'] = True
    #     case "network":
    #         netname = create_vpc_network(module.params['method'], module.params['folder_id'],
    #                                      module.params['networkname'],  module.params['netdesc'])
    #         result['message'] = netname
    #         if not "AlreadyExists" in netname:
    #             result['changed'] = True
    #     case "subnetwork":
    #         network_id = get_fact(module.params['method'],
    #                             "yc vpc network list --folder-id {} --format json".format(module.params['folder_id']),
    #                             module.params['networkname'], "id")
    #
    #         subnet = create_vpc_subnet(module.params['method'], module.params['subnetname'], module.params['subdesc'],
    #                                    network_id, module.params['zone'], module.params['cidr'], module.params['folder_id'])
    #
    #         result['message'] = subnet
    #         if not "ERROR" in subnet:
    #             result['changed'] = True
    #     case "vm":
    #         vm = create_vm_instance(module.params['method'], module.params['vm_name'], module.params['zone'],
    #                                 module.params['subnetname'], module.params['imgfamily'], module.params['disksize'],
    #                                 module.params['ram'], module.params['cores'], module.params['frac'],
    #                                 module.params['pathkey'], module.params['folder_id'])
    #
    #         vm_ip = get_fact(module.params['method'],
    #                               "yc compute instance list --folder-id {} --format json".format(module.params['folder_id']),
    #                               module.params['vm_name'], "network_interfaces")
    #
    #         result['message'] = vm_ip
    #         if not "AlreadyExists" in vm:
    #             result['changed'] = True


    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    # result['original_message'] = module.params['name']


    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    # if module.params['new']:
    #     result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    # if module.params['name'] == 'fail me':
    #     module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```

</details>

<details>
<summary>
playbook:
</summary>


```yaml
---
- name: Create vm in yandex cloud
  hosts: localhost
  tasks:
    - name: yc auth
      my_own_collection.yandex_cloud_elk.yc_create_vm:
        step: "auth"
        token: "{{ token }}"
    - name: yc create network
      my_own_collection.yandex_cloud_elk.yc_create_vm:
        step: "network"
        folder_id: "{{ folder_id }}"
        networkname: "learning"
        netdesc: "learning network"
        zone: "ru-central1-a"
        cidr: "10.0.1.0/24"
    - name: yc create subnetwork
      my_own_collection.yandex_cloud_elk.yc_create_vm:
        step: "subnetwork"
        folder_id: "{{ folder_id }}"
        networkname: "learning"
        subnetname: "learning-subnet"
        subdesc: "learning subnetwork"
        zone: "ru-central1-a"
        cidr: "10.0.1.0/24"
    - name: yc create vm1
      my_own_collection.yandex_cloud_elk.yc_create_vm:
        step: "vm"
        folder_id: "{{ folder_id }}"
        vm_name: "clickhouse-01"
        subnetname: "learning-subnet"
        imgfamily: "centos-7"
        disksize: "20GB"
        ram: "4GB"
        cores: "2"
        frac: "20"
        pathkey: "/home/vagrant/.ssh/id_rsa.pub"
      register: clickhouse_output
    - name: Add host to group 'clickhouse'
      ansible.builtin.add_host:
        name: clickhouse-01
        groups: clickhouse
        ansible_host: '{{ clickhouse_output.message[0].primary_v4_address.one_to_one_nat.address }}'
        ansible_user: yc-user
        primary_v4_address: '{{ clickhouse_output.message[0].primary_v4_address.address }}'
    - name: yc create vm2
      my_own_collection.yandex_cloud_elk.yc_create_vm:
        step: "vm"
        folder_id: "{{ folder_id }}"
        vm_name: "lighthouse-01"
        subnetname: "learning-subnet"
        imgfamily: "centos-7"
        disksize: "20GB"
        ram: "2GB"
        cores: "2"
        frac: "20"
        pathkey: "/home/vagrant/.ssh/id_rsa.pub"
      register: lighthouse_output
    - name: Add host to group 'lighthouse'
      ansible.builtin.add_host:
        name: lighthouse-01
        groups: lighthouse
        ansible_host: '{{ lighthouse_output.message[0].primary_v4_address.one_to_one_nat.address }}'
        ansible_user: yc-user
        primary_v4_address: '{{ lighthouse_output.message[0].primary_v4_address.address }}'
    - name: yc create vm2
      my_own_collection.yandex_cloud_elk.yc_create_vm:
        step: "vm"
        folder_id: "{{ folder_id }}"
        vm_name: "vector-01"
        subnetname: "learning-subnet"
        imgfamily: "centos-7"
        disksize: "20GB"
        ram: "2GB"
        cores: "2"
        frac: "20"
        pathkey: "/home/vagrant/.ssh/id_rsa.pub"
      register: vector_output
    - name: Add host to group 'vector'
      ansible.builtin.add_host:
        name: vector-01
        groups: vector
        ansible_host: '{{ vector_output.message[0].primary_v4_address.one_to_one_nat.address }}'
        ansible_user: yc-user
        primary_v4_address: '{{ vector_output.message[0].primary_v4_address.address }}'

- name: Install Clickhouse
  hosts: clickhouse
  gather_facts: no
  vars:
    clickhouse_listen_host_custom:
      - "{{ hostvars[ 'clickhouse-01' ].primary_v4_address }}"
    clickhouse_dbs_custom:
      - { name: logs }
  pre_tasks:
    - name: wait until clickhouse server is up
      wait_for:
        port: 22
        host: "{{ hostvars[ 'clickhouse-01' ].ansible_host }}"
        search_regex: OpenSSH
        timeout: 600
        delay: 10
      delegate_to: localhost
    - name: Gather facts for first time
      ansible.builtin.setup:
  roles:
    - role: clickhouse
  post_tasks:
    - name: Create table
      ansible.builtin.command: "clickhouse-client -q 'CREATE TABLE IF NOT EXISTS logs.local_log
        (file String, hostname String, message String, timestamp DateTime) Engine=Log;'"
      register: create_table
      failed_when: create_table.rc != 0 and create_table.rc !=57
      changed_when: create_table.rc == 0
      when: not ansible_check_mode

- name: Install Vector manual
  hosts: vector
  gather_facts: no
  vars:
    ip_clickhouse: "{{ hostvars[ 'clickhouse-01' ].primary_v4_address }}"
    vector_config:
      data_dir: /var/lib/vector
      sources:
        sample_file:
          type: file
          read_from: beginning
          ignore_older_secs: 600
          include:
            - /var/log/**/*.log
        vector_log:
          type: internal_logs
      sinks:
        to_clickhouse:
          type: clickhouse
          inputs:
            - sample_file
          endpoint: http://{{ ip_clickhouse }}:{{ port_clickhouse }}
          database: logs
          table: local_log
          skip_unknown_fields: true
          compression: gzip
          healthcheck:
            enabled: false
  collections:
    - my_own_collection.yandex_cloud_elk
  pre_tasks:
    - name: wait until vector server is up
      wait_for:
        port: 22
        host: "{{ hostvars[ 'vector-01' ].ansible_host }}"
        timeout: 600
        delay: 10
      delegate_to: localhost
    - name: Gather facts for first time
      ansible.builtin.setup:
  tasks:
    - name: import role vector
      ansible.builtin.import_role:
        name: vector-role

- name: Install lighthouse
  hosts: lighthouse
  gather_facts: no
  collections:
    - my_own_collection.yandex_cloud_elk
  pre_tasks:
    - name: wait until lighthouse server is up
      wait_for:
        port: 22
        host: "{{ hostvars[ 'lighthouse-01' ].ansible_host }}"
        timeout: 600
        delay: 10
      delegate_to: localhost
    - name: Gather facts for first time
      ansible.builtin.setup:
    - name: install git
      ansible.builtin.yum:
        name: git
        state: latest
        update_cache: yes
      become: true
  tasks:
    - name: import role nginx
      ansible.builtin.import_role:
        name: nginx-role
    - name: import role lighthouse
      ansible.builtin.import_role:
        name: lighthouse-role
```

</details>

<details>
<summary>
Создание инфраструктуры и установка стека:
</summary>

```bash
vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk/arhive$ ansible-playbook site2.yml --ask-vault-pass
Vault password: 
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Create vm in yandex cloud] *************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [yc auth] *******************************************************************************************************************************************************************************
ok: [localhost]

TASK [yc create network] *********************************************************************************************************************************************************************
changed: [localhost]

TASK [yc create subnetwork] ******************************************************************************************************************************************************************
changed: [localhost]

TASK [yc create vm1] *************************************************************************************************************************************************************************
changed: [localhost]

TASK [Add host to group 'clickhouse'] ********************************************************************************************************************************************************
changed: [localhost]

TASK [yc create vm2] *************************************************************************************************************************************************************************
changed: [localhost]

TASK [Add host to group 'lighthouse'] ********************************************************************************************************************************************************
changed: [localhost]

TASK [yc create vm2] *************************************************************************************************************************************************************************
changed: [localhost]

TASK [Add host to group 'vector'] ************************************************************************************************************************************************************
changed: [localhost]

PLAY [Install Clickhouse] ********************************************************************************************************************************************************************

TASK [wait until clickhouse server is up] ****************************************************************************************************************************************************
ok: [clickhouse-01 -> localhost]

TASK [Gather facts for first time] ***********************************************************************************************************************************************************
The authenticity of host '158.160.39.87 (158.160.39.87)' can't be established.
ECDSA key fingerprint is SHA256:r+ct7jkAgSI9R8ovqCqd9i3pLcVy1pytgzGwdhssPbc.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]

TASK [clickhouse : Include OS Family Specific Variables] *************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/precheck.yml for clickhouse-01

TASK [clickhouse : Requirements check | Checking sse4_2 support] *****************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Requirements check | Not supported distribution && release] ***************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/params.yml for clickhouse-01

TASK [clickhouse : Set clickhouse_service_enable] ********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Set clickhouse_service_ensure] ********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/install/yum.yml for clickhouse-01

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] ************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ****************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [clickhouse : Check clickhouse config, data and logs] ***********************************************************************************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
changed: [clickhouse-01] => (item=/etc/clickhouse-server)
changed: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
changed: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] ******************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Create users.d folder] *******************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate system config] ******************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate users config] *******************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate remote_servers config] **********************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate macros config] ******************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate zookeeper servers config] *******************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] ***************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Notify Handlers Now] ******************************************************************************************************************************************************

RUNNING HANDLER [clickhouse : Restart Clickhouse Service] ************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/service.yml for clickhouse-01

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] ***************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] *******************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [clickhouse : Set ClickHose Connection String] ******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Gather list of existing databases] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Delete database config] ******************************************************************************************************************************************
skipping: [clickhouse-01] => (item={'name': 'logs'}) 

TASK [clickhouse : Config | Create database config] ******************************************************************************************************************************************
changed: [clickhouse-01] => (item={'name': 'logs'})

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [clickhouse : Config | Generate dictionary config] **************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Create table] **************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector manual] *****************************************************************************************************************************************************************

TASK [wait until vector server is up] ********************************************************************************************************************************************************
ok: [vector-01 -> localhost]

TASK [Gather facts for first time] ***********************************************************************************************************************************************************
The authenticity of host '158.160.112.146 (158.160.112.146)' can't be established.
ECDSA key fingerprint is SHA256:nG9n9UdaFgI2t2cG/ffM+T2QAqmYUDVKua02oITsNho.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Create temp directory] ****************************************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Get vector distrib] *******************************************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Create root directory] ****************************************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Extract vector] ***********************************************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Copy vector to bin with owner and permissions] ****************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Configure vector.service from template] ***********************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : create config dir for vector] *********************************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Configure vector from template] *******************************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Create data directory] ****************************************************************************************************************
changed: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Flush handlers] ***********************************************************************************************************************

RUNNING HANDLER [my_own_collection.yandex_cloud_elk.vector-role : restarted vector service] **************************************************************************************************
changed: [vector-01]

PLAY [Install lighthouse] ********************************************************************************************************************************************************************

TASK [wait until lighthouse server is up] ****************************************************************************************************************************************************
ok: [lighthouse-01 -> localhost]

TASK [Gather facts for first time] ***********************************************************************************************************************************************************
The authenticity of host '130.193.48.24 (130.193.48.24)' can't be established.
ECDSA key fingerprint is SHA256:QNhSewCqVrm/u2wPd0/MjWIE+S2oexM/qrnG6rCRSK0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [lighthouse-01]

TASK [install git] ***************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : add repo nginx] ************************************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : install nginx] *************************************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : Configure nginx from template] *********************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : restarted nginx service] ***************************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : Flush handlers] ************************************************************************************************************************

RUNNING HANDLER [my_own_collection.yandex_cloud_elk.nginx-role : restarted nginx service] ****************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.lighthouse-role : Get lighthouse from git] **********************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.lighthouse-role : Configure nginx for lighthouse] ***************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.lighthouse-role : Flush handlers] *******************************************************************************************************************

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=27   changed=10   unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
lighthouse-01              : ok=10   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=10   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=12   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

</details>

<details>
<summary>
Идемпотентность:
</summary>

т.к. inventory не задан, ip адреса могут изменяться, то он формируется каждый раз при запуске playbook

```bash
vagrant@vm1:/netology_data/HW08-ansible-06-module/my_own_collection/yandex_cloud_elk/arhive$ ansible-playbook site2.yml --ask-vault-pass
Vault password: 
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Create vm in yandex cloud] *************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [yc auth] *******************************************************************************************************************************************************************************
ok: [localhost]

TASK [yc create network] *********************************************************************************************************************************************************************
ok: [localhost]

TASK [yc create subnetwork] ******************************************************************************************************************************************************************
ok: [localhost]

TASK [yc create vm1] *************************************************************************************************************************************************************************
ok: [localhost]

TASK [Add host to group 'clickhouse'] ********************************************************************************************************************************************************
changed: [localhost]

TASK [yc create vm2] *************************************************************************************************************************************************************************
ok: [localhost]

TASK [Add host to group 'lighthouse'] ********************************************************************************************************************************************************
changed: [localhost]

TASK [yc create vm2] *************************************************************************************************************************************************************************
ok: [localhost]

TASK [Add host to group 'vector'] ************************************************************************************************************************************************************
changed: [localhost]

PLAY [Install Clickhouse] ********************************************************************************************************************************************************************

TASK [wait until clickhouse server is up] ****************************************************************************************************************************************************
ok: [clickhouse-01 -> localhost]

TASK [Gather facts for first time] ***********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Include OS Family Specific Variables] *************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/precheck.yml for clickhouse-01

TASK [clickhouse : Requirements check | Checking sse4_2 support] *****************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Requirements check | Not supported distribution && release] ***************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/params.yml for clickhouse-01

TASK [clickhouse : Set clickhouse_service_enable] ********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Set clickhouse_service_ensure] ********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/install/yum.yml for clickhouse-01

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] ************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ****************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [clickhouse : Check clickhouse config, data and logs] ***********************************************************************************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
ok: [clickhouse-01] => (item=/etc/clickhouse-server)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] ******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Create users.d folder] *******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate system config] ******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate users config] *******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate remote_servers config] **********************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate macros config] ******************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate zookeeper servers config] *******************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] ***************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Notify Handlers Now] ******************************************************************************************************************************************************

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/service.yml for clickhouse-01

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: started] *****************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] *******************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [clickhouse : Set ClickHose Connection String] ******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Gather list of existing databases] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Delete database config] ******************************************************************************************************************************************
skipping: [clickhouse-01] => (item={'name': 'logs'}) 

TASK [clickhouse : Config | Create database config] ******************************************************************************************************************************************
skipping: [clickhouse-01] => (item={'name': 'logs'}) 

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
included: /home/vagrant/.ansible/roles/clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [clickhouse : Config | Generate dictionary config] **************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ************************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Create table] **************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector manual] *****************************************************************************************************************************************************************

TASK [wait until vector server is up] ********************************************************************************************************************************************************
ok: [vector-01 -> localhost]

TASK [Gather facts for first time] ***********************************************************************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Create temp directory] ****************************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Get vector distrib] *******************************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Create root directory] ****************************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Extract vector] ***********************************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Copy vector to bin with owner and permissions] ****************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Configure vector.service from template] ***********************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : create config dir for vector] *********************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Configure vector from template] *******************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Create data directory] ****************************************************************************************************************
ok: [vector-01]

TASK [my_own_collection.yandex_cloud_elk.vector-role : Flush handlers] ***********************************************************************************************************************

PLAY [Install lighthouse] ********************************************************************************************************************************************************************

TASK [wait until lighthouse server is up] ****************************************************************************************************************************************************
ok: [lighthouse-01 -> localhost]

TASK [Gather facts for first time] ***********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [install git] ***************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : add repo nginx] ************************************************************************************************************************
ok: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : install nginx] *************************************************************************************************************************
ok: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : Configure nginx from template] *********************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : restarted nginx service] ***************************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.nginx-role : Flush handlers] ************************************************************************************************************************

RUNNING HANDLER [my_own_collection.yandex_cloud_elk.nginx-role : restarted nginx service] ****************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.lighthouse-role : Get lighthouse from git] **********************************************************************************************************
ok: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.lighthouse-role : Configure nginx for lighthouse] ***************************************************************************************************
changed: [lighthouse-01]

TASK [my_own_collection.yandex_cloud_elk.lighthouse-role : Flush handlers] *******************************************************************************************************************

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=25   changed=1    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
lighthouse-01              : ok=10   changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=10   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=11   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

</details>



<details>
<summary>
Коллекция:
</summary>

Коллекция содержит lighthouse-role, vector-role, nginx-role два модуля: my_own_module и yc_create_vm. И в каталоге
Arhive playbook sute2.yml который демонстрирует поднятие виртуальных машин и установку соответсвующего стека.

[my_own_collection](https://github.com/alshelk/my_own_collection/tree/v1.1.0)

</details>


</details>

---