# Code Specs:

#### 1. Created three models:
    - Application
    - Chat
    - Message

#### 2. Used Redis to keep track of the auto incrementing fileds of *chat number* and *message number*.

#### 3. Used RabbitMQ in to handle the creation of the applications, chats and messages. To handle race conditions, the create requests are submitted to the queue which then processes them.

#### 4. The auto generated application token is created by creating a random key and appending the application name to it.

#### 5. The chat_count and message_count fileds are updated whenever a chat or a message is created respectivly.

#### 6. Searching through the bodies of the messages is performed using Elasticsearch.

#### 7. Indeces are added to the token, number and chatNumber fields to optimize the tables.

#### 8. Created a Docker Compose file that runs the:
    - MySQL Databse
    - RabbitMQ
    - Rails Server
    - Elasticsearch
    - Redis


## Instructions to run the code:
#### Write `sudo docker-compose up` to start building and running the whole stack.

#### The rails api is exposed on port `3000`

## Curl requests to test the API:

#### Create New Application

```sh
$ curl -X POST \
    http://localhost:3000/api/v1/applications \
    -H 'content-type: application/json' \
    -d '{
  	"name":"testApp"
  }'
```

#### View All Applications

```sh
$ curl -X GET \
    http://localhost:3000/api/v1/applications
```

#### View A Specefic Application
> :token is the generated token in the response of the create new application request
```sh
$ curl -X GET \
    http://localhost:3000/api/v1/applications/:token
```
#### Create New Chat
> :token is the generated token in the response of the create new application request

```sh
$ curl -X POST \
    http://localhost:3000/api/v1/applications/:token/chats \
    -H 'content-type: application/json' \
    -d '{
  	"description":"testing chats"
  }'
```

#### View All Chats Of A Specefic Application

> :token is the generated token in the response of the create new application request

```sh
$ curl -X GET \
    http://localhost:3000/api/v1/applications/:token/chats
```

#### View A Specefic Chat Of A Specefic Application
> :token is the generated token in the response of the create new application request
> :number is the generated number in the response of the create new chat request

```sh
$ curl -X GET \
    http://localhost:3000/api/v1/applications/:token/chats/:number
```

#### Create New Message
> :token is the generated token in the response of the create new application request
> :number is the generated number in the response of the create new chat request
```sh
$ curl -X POST \
    http://localhost:3000/api/v1/applications/:token/chats/:number/messages \
    -H 'content-type: application/json' \
    -d '{
  	"body":"an example of a message"
  }'
```

#### View All Messages Of A Specefic Chat In A Specefic Application

> :token is the generated token in the response of the create new application request
> :number is the generated number in the response of the create new chat request

```sh
$ curl -X GET \
    http://localhost:3000/api/v1/applications/:token/chats/:number/messages
```

#### View A Specefic Message Of A Specefic Chat In A Specefic Application

> :token is the generated token in the response of the create new application request
> :number is the generated number in the response of the create new chat request
> :messageNumber is the generated number in the response of the create new message request
```sh
$ curl -X GET \
    http://localhost:3000/api/v1/applications/:token/chats/:number/messages/:messageNumber
```

#### Search In Messages Of A Specefic Chat In A Specefic Application (Partial Match)
> :token is the generated token in the response of the create new application request
> :number is the generated number in the response of the create new chat request
```sh
$ curl -X POST \
    http://localhost:3000/api/v1/applications/:token/chats/:number/search \
    -H 'content-type: application/json' \
    -d '{
  	"query":"examp"
  }'
```

#### Update Requests Can Also Be Performed Using the Same APIs


# Thank You !