# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
- подключения к БД,
- вывода списка таблиц,
- вывода описания содержимого таблиц,
- выхода из psql.

```bash
$ docker run --rm -d -v pg-data:/var/lib/postgresql/data -v pg_backup:/backup --name pg_db -e POSTGRES_PASSWORD=passw0rd -p 5432:5432 postgres:13
efe01c16d8bdc114a5c43b2706c992e5272d85a5410b92138bf97ccfed1d8129
```

```text
- \l[+]   [PATTERN]      list databases

- Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")

- \dt[S+] [PATTERN]      list tables
  \d[S+]                 list tables, views, and sequences

- \d[S+]  NAME           describe table, view, sequence, or index

- \q                     quit psql

```

## Задача 2

Используя `psql`, создайте БД `test_database`.

```bash
$ docker exec -t pg_db psql -c 'CREATE DATABASE test_database' -U postgres
CREATE DATABASE
$ docker exec -t pg_db psql -c '\l+' -U postgres
                                                                     List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description                 
---------------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7901 kB | pg_default | default administrative connection database
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | unmodifiable empty database
               |          |          |            |            | postgres=CTc/postgres |         |            | 
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | default template for new databases
               |          |          |            |            | postgres=CTc/postgres |         |            | 
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7753 kB | pg_default | 
(4 rows)
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```bash
$ cat ./test_dump.sql | docker exec -i pg_db psql -U postgres test_database 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```sql
test_database=# ANALYZE;
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```sql
# SELECT tablename, attname, avg_width FROM pg_stats WHERE avg_width = (SELECT max(avg_width) FROM pg_stats WHERE tablename='orders');
 tablename | attname | avg_width 
-----------+---------+-----------
 orders    | title   |        16
(1 row)

```

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

```sql
test_database=# BEGIN;
BEGIN
test_database=*# CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS ( orders );
CREATE TABLE
test_database=*# CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS ( orders );
CREATE TABLE
test_database=*# CREATE RULE orders_insert_to_1 AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_1 VALUES ( NEW.* );
CREATE RULE
test_database=*# CREATE RULE orders_insert_to_2 AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_2 VALUES ( NEW.* );
CREATE RULE
test_database=*# SAVEPOINT create_tables_and_rules;
SAVEPOINT
test_database=*# WITH deleted AS ( DELETE FROM ONLY orders WHERE price > 499 returning * ) INSERT INTO orders_1 SELECT * FROM deleted;
INSERT 0 3
test_database=*# WITH deleted AS ( DELETE FROM ONLY orders WHERE price <= 499 returning * ) INSERT INTO orders_2 SELECT * FROM deleted;
INSERT 0 5
test_database=*# COMMIT;
COMMIT
test_database=# \dt+
                               List of relations
 Schema |   Name   | Type  |  Owner   | Persistence |    Size    | Description 
--------+----------+-------+----------+-------------+------------+-------------
 public | orders   | table | postgres | permanent   | 8192 bytes | 
 public | orders_1 | table | postgres | permanent   | 8192 bytes | 
 public | orders_2 | table | postgres | permanent   | 8192 bytes | 
(3 rows)

test_database=# select * from orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
  7 | Me and my bash-pet   |   499
(8 rows)

test_database=# select * from only orders ;
 id | title | price 
----+-------+-------
(0 rows)

test_database=# select * from orders_1
test_database-# ;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# select * from orders_2;
 id |        title         | price 
----+----------------------+-------
  7 | Me and my bash-pet   |   499
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(5 rows)

test_database=# EXPLAIN select * from  orders WHERE price <= 499;
                              QUERY PLAN                              
----------------------------------------------------------------------
 Append  (cost=0.00..16.50 rows=131 width=181)
   ->  Seq Scan on orders orders_1  (cost=0.00..1.10 rows=4 width=24)
         Filter: (price <= 499)
   ->  Seq Scan on orders_2  (cost=0.00..14.75 rows=127 width=186)
         Filter: (price <= 499)
(5 rows)


```

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

```text
Можно сразу настроить декларативное секционирование. Т.е. декларировать, что таблица разделена на секции. 
Сама таблица (секционная таблица) является виртуальной. Сама такая таблица не хранится, а хранятся ее секции
которые являются обычными таблицами связанными с секционной. Все строки, вставляемые в секционированную таблицу, 
перенаправляются в соответствующие секции в зависимости от значений столбцов ключа разбиения.  

```

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

```bash
$ docker exec pg_db pg_dump -U postgres test_database > ./test_database_dump.sql 
$ ls
test_database_dump.sql

```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---