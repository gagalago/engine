# Babili Engine <a href="https://travis-ci.org/Babili/engine">![Build status](https://travis-ci.org/Babili/engine.svg?branch=master)</a>


Babili is a real-time chat backend built with Ruby, Rails, Node, Socket.io and Docker.

See https://github.com/Babili/babili for the Getting started guide

The engine is the main service of the API.


## Environment variables

| Option | Default Value | Type | Required? | Description  | Example |
| ---- | ----- | ------ | ----- | ------ | ----- |
| `DB_NAME` | `"engine"`| String | Optional | | `"my_db"` |
| `DB_HOST` | `""`| String | Optional | | `"localhost"` |
| `DB_USER` | `"postgres"`| String | Optional | | `"localhost"` |
| `DB_PORT` | `"5432"`| String | Optional | | `"5432"` |
| `DB_PASSWORD` | `""`| String | Optional | | `"mypwd"` |
| `SIDEKIQ_REDIS_URL` | `""`| String | Required | | `"redis://redis/2"` |
| `RABBITMQ_HOST` | `""`| String | Required | | `"rabbitmq"` |
| `RABBITMQ_PORT` | `""`| String | Required | | `"5672"` |
| `RABBITMQ_USER` | `""`| String | Required | | `"root"` |
| `RABBITMQ_PASSWORD` | `""`| String | Required | | `"root"` |
| `RABBITMQ_EXCHANGE_NAME` | `""`| String | Required | | `"babili"` |
| `RABBITMQ_EXCHANGE_DURABLE` | `""`| String | Required | | `"true"` |
| `RAILS_ENV` | `""`| String | Required | | `"development"` |


# Existing api routes: 

See https://github.com/Babili/engine/blob/master/API.md

## Contributors

Babili is the product of the Collaboration of the Spin42 team (http://spin42.com) and the Commuty one (https://www.commuty.net).
