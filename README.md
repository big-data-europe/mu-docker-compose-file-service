# Mu Docker Compose File Service

A simple service to manage Docker Compose files.

It provides an endpoint to retrieve Docker Compose Files from the backend and return the as `docker-compose.yml`.

### /:id

This call accepts an `id` parameter (mandatory). The microservice queries the database with the following SPARQL query and returns the value of the content attribute. As it is filtering on the uuid, it should only return one row. Not existing URI returns an empty yaml file. Missing the `id` parameter will result in an 404 Not Found.

#### Query:

``` SPARQL
select ?content
where {
  ?composeFile a <http://stackbuilder.semte.ch/vocabularies/core/DockerCompose>;
     <http://mu.semte.ch/vocabularies/core/uuid> '#{id}';
     <http://stackbuilder.semte.ch/vocabularies/core/text> ?content.
}
```

#### Example call:

```
curl http://localhost:666/58CFDE760675FB0009000004
```
#### Example response yaml file:
``` yml
version: "2"
services:
  identifier:
    image: semtech/mu-identifier:1.0.0
    links:
      - dispatcher:dispatcher
    ports:
      - "80:80"
  dispatcher:
    image: semtech/mu-dispatcher:1.0.1
    links:
      - resource:resource
    volumes:
      - ./config/dispatcher:/config
  db:
    image: tenforce/virtuoso:1.0.0-virtuoso7.2.4
    environment:
      SPARQL_UPDATE: "true"
      DEFAULT_GRAPH: "http://mu.semte.ch/application"
    ports:
      - "8890:8890"
    volumes:
      - ./data/db:/data
  resource:
    image: semtech/mu-cl-resources:1.12.1
    links:
      - db:database
    volumes:
      - ./config/resources:/config
```
