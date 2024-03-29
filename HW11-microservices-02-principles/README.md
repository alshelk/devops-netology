# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

<details>
<summary>
Ответ
</summary>

Заданным требованиям удовлетворяет большинство решений для API Gateway, если не все ( а их сейчас больше 40 судя по [sourceforge](https://sourceforge.net/software/api-gateways/) ).
Так же предпочтительны open-source проекты.
Например:
Nginx, Kong Gateway, Tyk, KrakenD, Apache APISIX, WSO2 API Manager ...

| Требования | Nginx  | Kong Gateway | Tyk | KrakenD | Apache APISIX | WSO2 API Manager |
|------------|--------|--------------|----------|----------|----------|----------|
| маршрутизация запросов к нужному сервису на основе конфигурации      | +  | + |+  |+  |+  |+  |
| возможность проверки аутентификационной информации в запросах      | +  | +  |+  |+  |+  |+  |
| обеспечение терминации HTTPS     | +  | +  |+  |+  |+  |+  |

Облачные API Gateway такие, как Amazon ELB, Cloudflare, Akamai, Google Apigee API Management и т.п. рассматривать не 
будем, что бы исключить зависимость от провайдера услуг, хотя для небольшой фирмы или какого нибудь стратапа
данные сервисы будут хорошим решением.

Так как требования достаточно скромны, а другой вводной информации нет, и не нужно дополнительных сервисов, 
я бы выбрал Nginx, т.к. это популярный, хорошо зарекомендовавший
себя продукт, с большим сообществом и большим количеством примеров с документацией, на базе которого реализованы 
многие популярные API Gateway с расширенным функционалом. Или же попробовал KrakenD. 
На сайте разработчика заявлена высокая производительность, превышающая Kong и Tyk.



</details>

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

<details>
<summary>
Ответ
</summary>

| Задача                                                | Apache Kafka   | Redis        | RabbitMQ     | Apache ActiveMQ | ZeroMQ       |
|-------------------------------------------------------|----------------|--------------|--------------|-----------------|--------------|
| Поддержка кластеризации для обеспечения надежности    | +              | +            | +            | +               | +            |
| Хранение сообщений на диске в процессе доставки       | +              | -            | +            | +               | -            |
| Высокая скорость работы                               | 1 млн mes/s    | 1 млн mes/s  | ~ 50 т mes/s | ~ 10 т tr/s     | 1 млн mes/s  |
| Поддержка различных форматов сообщений                | +              | +            | +            | -               | +            |
| Разделение прав доступа к различным потокам сообщений | +              | +            | +            | +               | +            |
| Простота эксплуатации                                 | +              | +            | +            | +               | +            |

Таблица показывает, что всем требованиям соответствуют Apache Kafka и возможно RebbitMQ смотря что считать 
высокой скоростью работы. Из различий можно отметить, что RebbitMQ использует push модель, Kafka - pull.
Конечное решение будет зависеть от задач. Например: Если необходимо повторно анализировать полученные данные,
то из-за способа потребления сообщений и отсутствия приоритета, больше подойдет Kafka. Но если важна последовательность 
и гарантия доставки, то лучше подойдет RebbitMQ.


</details>

## Задача 3: API Gateway * (необязательная)

### Есть три сервиса:

**minio**
- хранит загруженные файлы в бакете images,
- S3 протокол,

**uploader**
- принимает файл, если картинка сжимает и загружает его в minio,
- POST /v1/upload,

**security**
- регистрация пользователя POST /v1/user,
- получение информации о пользователе GET /v1/user,
- логин пользователя POST /v1/token,
- проверка токена GET /v1/token/validation.

### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:

**POST /v1/register**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/user.

**POST /v1/token**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/token.

**GET /v1/user**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис security GET /v1/user.

**POST /v1/upload**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис uploader POST /v1/upload.

**GET /v1/user/{image}**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис minio GET /images/{image}.

### Ожидаемый результат

Результатом выполнения задачи должен быть docker compose файл, запустив который можно локально выполнить следующие команды с успешным результатом.
Предполагается, что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки, который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации входящих запросов.
Авторизация
curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token

**Загрузка файла**

curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload

**Получение файла**
curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

---

#### [Дополнительные материалы: как запускать, как тестировать, как проверить](https://github.com/netology-code/devkub-homeworks/tree/main/11-microservices-02-principles)

много воды, даже поверхностно нет материала, который требуется для простых заданий в домашке

---