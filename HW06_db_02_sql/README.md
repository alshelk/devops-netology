# Домашнее задание к занятию "2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

docker-compose манифест:

```sql
$ cat docker-compose.yaml 
version: '2.5.1'

networks:
  monitoring:
    driver: bridge

volumes:
    pg_data: {}
    pg_backup: {}

services:
  pg_db:
    image: postgres:12
    restart: always
    environment:
      POSTGRES_PASSWORD: passw0rd
    volumes:
      - pg_data:/var/lib/postgresql/data
      - pg_backup:/backup
    ports:
      - "5432:5432"

```

команда docker:

```sql
$ docker run --rm -d -v pg-data:/var/lib/postgresql/data -v pg_backup:/backup \
> --name pg_db -e POSTGRES_PASSWORD=passw0rd -p 5432:5432 postgres:12

```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

```sql
postgres=# CREATE USER "test-admin-user" WITH PASSWORD '123';
CREATE ROLE
postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# \c test_db;
test_db=# CREATE TABLE orders (
test_db(# id serial PRIMARY KEY,
test_db(# name varchar(40),
test_db(# price integer);
CREATE TABLE
test_db=# CREATE TABLE clients (
id serial PRIMARY KEY,
surname varchar(40),
country varchar(40),
order_no integer REFERENCES orders (id));
CREATE TABLE
test_db=# CREATE INDEX country_idx ON clients (country);
CREATE INDEX
test_db=# GRANT ALL ON ALL TABLES IN SCHEMA public TO "test-admin-user";
GRANT
test_db=# CREATE USER "test-simple-user" WITH PASSWORD '321';
CREATE ROLE
test_db=# GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA public TO "test-simple-user";
GRANT
```


Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```sql
postgres=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description                 
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7969 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            | 
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 8097 kB | pg_default | 
(4 rows)

test_db=# \d+;
                            List of relations
 Schema |      Name      |   Type   |  Owner   |    Size    | Description 
--------+----------------+----------+----------+------------+-------------
 public | clients        | table    | postgres | 0 bytes    | 
 public | clients_id_seq | sequence | postgres | 8192 bytes | 
 public | orders         | table    | postgres | 0 bytes    | 
 public | orders_id_seq  | sequence | postgres | 8192 bytes | 
(4 rows)

test_db=# \d+ clients
                                                        Table "public.clients"
  Column  |         Type          | Collation | Nullable |               Default               | Storage  | Stats target | Description 
----------+-----------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id       | integer               |           | not null | nextval('clients_id_seq'::regclass) | plain    |              | 
 surname  | character varying(40) |           |          |                                     | extended |              | 
 country  | character varying(40) |           |          |                                     | extended |              | 
 order_no | integer               |           |          |                                     | plain    |              | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_idx" btree (country)
Foreign-key constraints:
    "clients_order_no_fkey" FOREIGN KEY (order_no) REFERENCES orders(id)
Access method: heap

test_db=# \d+ orders;
                                                       Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description 
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
 name   | character varying(40) |           |          |                                    | extended |              | 
 price  | integer               |           |          |                                    | plain    |              | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_no_fkey" FOREIGN KEY (order_no) REFERENCES orders(id)
Access method: heap

est_db=# SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE table_catalog = 'test_db' and table_schema = 'public';
     grantee      | table_name | privilege_type 
------------------+------------+----------------
 postgres         | orders     | INSERT
 postgres         | orders     | SELECT
 postgres         | orders     | UPDATE
 postgres         | orders     | DELETE
 postgres         | orders     | TRUNCATE
 postgres         | orders     | REFERENCES
 postgres         | orders     | TRIGGER
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | DELETE
 postgres         | clients    | INSERT
 postgres         | clients    | SELECT
 postgres         | clients    | UPDATE
 postgres         | clients    | DELETE
 postgres         | clients    | TRUNCATE
 postgres         | clients    | REFERENCES
 postgres         | clients    | TRIGGER
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | UPDATE
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | TRIGGER
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
(36 rows)



```


## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|


```sql
test_db=# INSERT INTO clients (surname, country) VALUES 
test_db-# ('Иванов Иван Иванович', 'USA'),
test_db-# ('Петров Петр Петрович', 'Canada'),
test_db-# ('Иоганн Себастьян Бах', 'Japan'),
test_db-# ('Ронни Джеймс Дио', 'Russia'),
test_db-# ('Ritchie Blackmore', 'Russia');
INSERT 0 5

test_db=# INSERT INTO orders (name, price) VALUES 
test_db-# ('Шоколад', 10),
test_db-# ('Принтер', 3000),
test_db-# ('Книга', 500),
test_db-# ('Монитор', 7000),
test_db-# ('Гитара', 4000);
INSERT 0 5

```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```sql
test_db=# SELECT count(*) FROM orders;
 count 
-------
     5
(1 row)

test_db=# SELECT count(*) FROM clients;
 count 
-------
     5
(1 row)

```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```sql
test_db=# WITH ins (surname, ordername) AS ( VALUES
 ('Иванов Иван Иванович', 'Книга'),
 ('Петров Петр Петрович', 'Монитор'),
 ('Иоганн Себастьян Бах', 'Гитара'))
UPDATE clients as cl SET order_no=t.id 
FROM (SELECT o.id, ins.surname FROM orders as o 
 JOIN ins ON ins.ordername = o.name) as t(id, surname) 
WHERE t.surname = cl.surname;
UPDATE 3

```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```sql
test_db=# SELECT * FROM clients WHERE order_no IS NOT NULL;
 id |       surname        | country | order_no 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(3 rows)

```
 

Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

```sql
test_db=# EXPLAIN SELECT * FROM clients WHERE order_no IS NOT NULL;
                       QUERY PLAN                       
--------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.05 rows=3 width=47)
   Filter: (order_no IS NOT NULL)
(2 rows)

```

Приведите получившийся результат и объясните что значат полученные значения. 

```text

Seq Scan on clients - говорит что чтение из таблицы clients выполнялось последовательно, блок за блоком.
cost=0.00..1.05 - Приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, где 0.00 - затраты на получение первой строки, 1.05 на получение всех строк
rows - Приблизительное количество возвращаемых строк при выполнении операции Seq Scan
width - Ожидаемый средний размер одной строки в байтах.
Filter: (order_no IS NOT NULL) - говорит что каждая запись сравнивается с условием и если оно выполняется, выводится в результат. Иначе - отбрасывается

Это все планируемые результаты запроса.
```


```sql
test_db=# EXPLAIN (ANALYZE) SELECT * FROM clients WHERE order_no IS NOT NULL;
                                            QUERY PLAN                                            
--------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.05 rows=3 width=47) (actual time=0.027..0.031 rows=3 loops=1)
   Filter: (order_no IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.120 ms
 Execution Time: 0.060 ms
(5 rows)

```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---