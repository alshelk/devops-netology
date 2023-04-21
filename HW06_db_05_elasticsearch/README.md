# Домашнее задание к занятию 5. «Elasticsearch»

## Задача 1

В этом задании вы потренируетесь в:

- установке Elasticsearch,
- первоначальном конфигурировании Elasticsearch,
- запуске Elasticsearch в Docker.

Используя Docker-образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для Elasticsearch,
- соберите Docker-образ и сделайте `push` в ваш docker.io-репозиторий,
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины.

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`,
- имя ноды должно быть `netology_test`.

В ответе приведите:

- текст Dockerfile-манифеста,
- ссылку на образ в репозитории dockerhub,
- ответ `Elasticsearch` на запрос пути `/` в json-виде.

Подсказки:

- возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
- при некоторых проблемах вам поможет Docker-директива ulimit,
- Elasticsearch в логах обычно описывает проблему и пути её решения.

Далее мы будем работать с этим экземпляром Elasticsearch.

#### Решение:

[Dockerfile](src%2FDockerfile)

[elastic:7.14.0](https://hub.docker.com/r/alshelk/elastic)

```bash
vagrant@vm1:~$ curl -XGET http://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "netology",
  "cluster_uuid" : "7eH-j2CeT2au0o-kFU46JA",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы,
- изучать состояние кластера,
- обосновывать причину деградации доступности данных.

Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `Elasticsearch` 3 индекса в соответствии с таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

Получите состояние кластера `Elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

#### Решение

Список индексов:

```bash
vagrant@vm1:~$ curl -GET localhost:9200/_cat/indices?pretty
green  open ind-1 mZ-RrGh2QwCvFsbz6HnEqg 1 0 0 0 208b 208b
yellow open ind-3 d1OxW2egRum6SaaP8Lo3bg 4 2 0 0 832b 832b
yellow open ind-2 GcZnX40uRDGquEr4kxVXeQ 2 1 0 0 416b 416b
* Connection #0 to host localhost left intact

```

Состояние кластера:

```bash
vagrant@vm1:~$ curl -GET localhost:9200/_cluster/health?pretty
{
  "cluster_name":"netology",
  "status":"yellow",
  "timed_out":false,
  "number_of_nodes":1,
  "number_of_data_nodes":1,
  "active_primary_shards":7,
  "active_shards":7,
  "relocating_shards":0,
  "initializing_shards":0,
  "unassigned_shards":10,
  "delayed_unassigned_shards":0,
  "number_of_pending_tasks":0,
  "number_of_in_flight_fetch":0,
  "task_max_waiting_in_queue_millis":0,
  "active_shards_percent_as_number":41.17647058823529
}
```

```text
Индексы находятся в состоянии yellow потому что, кластер у нас из 1 ноды и реплики 
размещать негде. А они указаны для ind-2 и ind-3 : 1 и 2 соответственно.

Т.к. индексы находятся в состоянии yellow то и кластер находится в состоянии yellow.
Часть шард в состоянии unassigned.
```

```bash
vagrant@vm1:~$ curl -GET localhost:9200/_cat/shards
ind-1 0 p STARTED    0 208b 172.17.0.2 netology_test
ind-3 3 p STARTED    0 208b 172.17.0.2 netology_test
ind-3 3 r UNASSIGNED                   
ind-3 3 r UNASSIGNED                   
ind-3 2 p STARTED    0 208b 172.17.0.2 netology_test
ind-3 2 r UNASSIGNED                   
ind-3 2 r UNASSIGNED                   
ind-3 1 p STARTED    0 208b 172.17.0.2 netology_test
ind-3 1 r UNASSIGNED                   
ind-3 1 r UNASSIGNED                   
ind-3 0 p STARTED    0 208b 172.17.0.2 netology_test
ind-3 0 r UNASSIGNED                   
ind-3 0 r UNASSIGNED                   
ind-2 1 p STARTED    0 208b 172.17.0.2 netology_test
ind-2 1 r UNASSIGNED                   
ind-2 0 p STARTED    0 208b 172.17.0.2 netology_test
ind-2 0 r UNASSIGNED                   
* Connection #0 to host localhost left intact

```

## Задача 3

В этом задании вы научитесь:

- создавать бэкапы данных,
- восстанавливать индексы из бэкапов.

Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
эту директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.


```bash
vagrant@vm1:~$ curl -XPUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d '{ "type": "fs", "settings": { "location": "/elasticsearch/snapshots", "compress": true} }'
{
  "acknowledged" : true
}

vagrant@vm1:~$ curl -X POST "localhost:9200/_snapshot/netology_backup/_verify?pretty"
{
  "nodes" : {
    "Zr1SOc24S2uBPshJFsq8JA" : {
      "name" : "netology_test"
    }
  }
}

```


Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```bash
vagrant@vm1:~$ curl -GET localhost:9200/_cat/indices?pretty
green open test RVQn0zhhSzqAsMXHc6x92w 1 0 0 0 208b 208b

```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `Elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`.

```bash
vagrant@vm1:~$ curl -X PUT "localhost:9200/_snapshot/netology_backup/my_snapshot?pretty"
{
  "accepted" : true
}

vagrant@vm1:~$ curl -X GET "localhost:9200/_snapshot/netology_backup/my_snapshot?pretty"
{
  "snapshots" : [
    {
      "snapshot" : "my_snapshot",
      "uuid" : "vERGw9UiQ2OdSBdbeEkCgA",
      "repository" : "netology_backup",
      "version_id" : 7140099,
      "version" : "7.14.0",
      "indices" : [
        "test"
      ],
      "data_streams" : [ ],
      "include_global_state" : true,
      "state" : "SUCCESS",
      "start_time" : "2023-04-21T16:07:16.514Z",
      "start_time_in_millis" : 1682093236514,
      "end_time" : "2023-04-21T16:07:16.715Z",
      "end_time_in_millis" : 1682093236715,
      "duration_in_millis" : 201,
      "failures" : [ ],
      "shards" : {
        "total" : 1,
        "failed" : 0,
        "successful" : 1
      },
      "feature_states" : [ ]
    }
  ]
}

[elasticsearch@c120c40aab24 elasticsearch]$ ls snapshots/
index-0  index.latest  indices  meta-vERGw9UiQ2OdSBdbeEkCgA.dat  snap-vERGw9UiQ2OdSBdbeEkCgA.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```bash
vagrant@vm1:~$ curl -XDELETE http://localhost:9200/test
{"acknowledged":true}
vagrant@vm1:~$ curl -XPUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d '{ "settings" : { "index": { "number_of_shards" : 1, "number_of_replicas" : 0} } }'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
vagrant@vm1:~$ curl  -GET localhost:9200/_cat/indices
green open test-2 G6XJu4gzQvuP2g68gagRpg 1 0 0 0 208b 208b

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `Elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```bash
vagrant@vm1:~$ curl -X POST "localhost:9200/_snapshot/netology_backup/my_snapshot/_restore?pretty"
{
  "accepted" : true
}

vagrant@vm1:~$ curl  -GET localhost:9200/_cat/indices
green open test-2 G6XJu4gzQvuP2g68gagRpg 1 0 0 0 208b 208b
green open test   rgmKIeEATYq14ZSz-prfDw 1 0 0 0 208b 208b

```

Подсказки:

- возможно, вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `Elasticsearch`.

---

