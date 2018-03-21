![Cozy](https://cozy.io/fr/images/cozy-logo-name-horizontal-blue.svg)

# Cozy-stack

We all have a life and a digital life. Cozy gathers them.
In your Cozy, you have all your personal data: pictures, health, bank, holidays, accessible only by you. Welcome in your new digital home. 

This is a minimal, yet configurable image for cozy-stack.

## Supported tags

* `edge`, `latest` ([Dockerfile](https://github.com/xylphid/dockers/blob/master/cozycloud/beta/Dockerfile))

## How to use this image

This image does not expose any port but the application is reachable through port 8080 (_default value_).

`$ docker run --name some-name -d -p 80:8080 xylphid/cozy-stack:latest`

Then you can hit `http://localhost/` or `http://host-ip` in you browser.

## How to compose with this image

See [cozy documentation](https://docs.cozy.io/fr/install/manual/#configuration) to configure NGinx.

    version: "3.4"
    
    services:
      couchdb:
        image: couchdb:2.1.1
    
      redis:
        image: redis:3.2.11-alpine
    
      app:
        depends_on:
          - couchdb
        environment:
          COZY_DOMAIN: cozy.docker
          COZY_COUCHDB_URL: "http://couchdb:5984/"
        image: xylphid/cozy-stack:latest
        ports:
          - 80:8080
        restart: always

### Compose with [traefik](https://traefik.io)

    version: "3.4"
    
    services:
      couchdb:
        image: couchdb:2.1.1
    
      redis:
        image: redis:3.2.11-alpine
    
      app:
        depends_on:
          - couchdb
          - redis
        environment:
          COZY_ADMIN_HOST: 0.0.0.0
          COZY_DOMAIN: cozy.docker
          COZY_COUCHDB_URL: "http://couchdb:5984/"
        image: xylphid/cozy-core:2018-m1-s4
        labels:
          traefik.enable: "true"
          traefik.backend: "Cozy"
          traefik.frontend.headers.SSLRedirect: "true"
          traefik.frontend.rule: "HostRegexp:cozy.docker,{subdomain:[a-z]+}.cozy.docker"
          traefik.port: "8080"
        restart: always

This configuration redirect any cozy subdomain to the right container. Consider configuring your [DNS](https://docs.cozy.io/fr/install/manual/#dns) as explained in the documentation.

## Environments

Here are supported environments variable and its definition :

* `COZY_DOMAIN` : Your domain
* `COZY_PORT` : Cozy port (default : 8080)
* `COZY_APPS` : Installed application (default : drive,photos,collect,settings)
* `COZY_ADMIN_PASSWORD` : Adminsitrator password
* `COZY_ADMIN_HOST` : Admin host (default : )
* `COZY_ADMIN_PORT` : Admin port (default : 6060)
* `COZY_ADMIN_PASSPHRASE` : Admin passphrase
* `COZY_COUCHDB_URL` : CouchDB URL (default : http://couchdb:5984/)
* `COZY_MAIL_REPLY` : Mail noreply address
* `COZY_MAIL_REPLY_NAME` : Mail noreply name
* `COZY_SMTP_HOST` : SMTP server address
* `COZY_SMTP_PORT` : SMTP server port (default : 465)
* `COZY_SMTP_USERNAME` : SMTP account
* `COZY_SMTP_PASSWORD` : SMTP password
* `COZY_SMTP_TLS_ENABLE` : SMTP TLS enable

## Quick reference

* [Cozy Cloud](https://cozy.io/)
* [Documentation](https://docs.cozy.io/)

## Image inheritance

This docker image inherits from [alpine:3.7](https://hub.docker.com/_/alpine/) and [golang:1.10.0-alpine3.7](https://hub.docker.com/_/golang/). \
The `Dockerfile` is mostly based on (https://hub.docker.com/r/moritzheiber/cozy-stack/).