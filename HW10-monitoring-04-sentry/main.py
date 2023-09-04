import sentry_sdk
from os import getenv
from dotenv import load_dotenv, find_dotenv


def before_send(event, hint):
    if 'exc_info' in hint:
        exc_type, exc_value, tb = hint['exc_info']
        if isinstance(exc_value, ZeroDivisionError):
            event['fingerprint'] = ['Error Division by zero']
    return event

load_dotenv(find_dotenv())

sentry_sdk.init(
    dsn=getenv("SENTRY_DSN"),
    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    traces_sample_rate=1.0,
    # Set profiles_sample_rate to 1.0 to profile 100%
    # of sampled transactions.
    # We recommend adjusting this value in production.
    profiles_sample_rate=1.0,
    environment="test",
    release="py_script@1.0.0",
    before_send=before_send,
)



my_err = int(input('Введите номер ошибки от 0 до 5:'))

match my_err:
    case 0:
        sentry_sdk.set_tag("myerror", 0)
        sentry_sdk.capture_message("hi")
    case 1:
        sentry_sdk.set_tag("myerror", 1)
        raise Exception("It is a error")
    case 2:
        sentry_sdk.set_tag("myerror", 2)
        print(test_fn)
    case 3:
        sentry_sdk.set_tag("myerror", 3)
        division_by_zero = 1 / 0
    case 4:
        sentry_sdk.set_tag("myerror", 4)
        sentry_sdk.capture_mssage("hi")
    case 5:
        sentry_sdk.set_tag("myerror", 5)
        before_send()

