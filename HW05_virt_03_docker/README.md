# Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполнения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.


    ссылка https://hub.docker.com/r/alshelk/content-nginx

    docker run -d -p 80:80 alshelk/content-nginx:0.1

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Ответы:
    
* Учитывая что приложение монолитное и высоконагруженное, его можно разместить на физической машине 
    или на виртуальной машине для облегчения миграции. 
    
* Nodejs веб-приложение можно разместить в контейнерах, что бы упростить развертывание. (https://hub.docker.com/_/node/)

* Мобильное приложение c версиями для Android и iOS - виртуальная машина или физическое устройство.
    
* Шина данных на базе Apache Kafka - исходя из [документации](https://kafka.apache.org/documentation/#gettingStarted) (It can be deployed on bare-metal hardware,
    virtual machines, and containers in on-premise as well as cloud environments.) подходит любой способ установки.
    
* Elasticsearch - из [документации](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html) : "Use dedicated hosts". В рабочей среде 
рекомендуется запускать Elasticsearch на выделенном хосте или в качестве основного сервиса,
т.к. некоторые функции предполагают, что это единственное ресурсоемкое приложение на хосте
или в контейнере.

* Мониторинг-стек на базе Prometheus и Grafana - можно использовать контейнер или vm для упрощения 
развертывания и миграции.

* MongoDB, как основное хранилище данных для java-приложения - предпочтительнее использовать
физическую машину или виртуальную, хотя можно запустить и в контейнере, но хранить данные вне
контейнера. (https://www.mongodb.com/compatibility/docker)

* Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry - Docker Registry
уже поставляется в контейнере. [GitLab](https://docs.gitlab.com/ee/install/install_methods.html) Поддерживает
все варианты установки. Так же рекомендуют "Используйте, если вам нужен наиболее зрелый, масштабируемый метод." -
установку Linux package на физическую или виртуальную машину с рекомендованными характеристиками по процессору и 
оперативной памяти. Или же "Пакеты GitLab в контейнере Docker.	Используйте, если вы знакомы с Docker."


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.


    $ docker run -dt --name centos --mount type=bind,source=/home/vagrant/docker/data,destination=/data centos
    3dfe7d3d31c38a41789df166a199d2e4e3959d39b9af87422d9a1f9143df42f2
    $ docker run -dt --name debian --mount type=bind,source=/home/vagrant/docker/data,destination=/data debian
    f315d421595c4d7fffcb98eb9d10123231bc889f9d683b9755d8e86e289887a1
    $ docker ps
    CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS              PORTS     NAMES
    f315d421595c   debian    "bash"        13 seconds ago       Up 11 seconds                 debian
    3dfe7d3d31c3   centos    "/bin/bash"   About a minute ago   Up About a minute             centos
    $ docker exec centos echo 'test file created in CentOS docker' > /data/testfile
    $ echo 'test file created on host' > data/testfile2
    $ docker exec debian ls /data
    testfile
    testfile2
    $ docker exec debian cat /data/testfile
    test file created in CentOS docker
    $ docker exec debian cat /data/testfile2
    test file created on host


## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

    https://hub.docker.com/r/alshelk/ansible

    docker pull alshelk/ansible:2.9.24