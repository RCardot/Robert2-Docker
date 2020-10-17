# Robert2-Docker

This is a preliminary dockerized version of robertmanager (https://robertmanager.org/  and https://github.com/Robert-2).

!! This repo is for personnal training. See here https://github.com/Robert-2/Robert2/tree/master/server/docker for official docker version.

The Dockerfile builds the app on a debian-apache2-php7.3 machine

The docker-compose.yml file deploy the app imag (built from the previous Dockerfile) pulled from my docker hub + set up a mysql5.7 database.

Both can communicate through the inter-docker network

IMPORTANT NOTE: This is still a work in progress intended to run on local machine for test purpose
