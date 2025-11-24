#!/bin/bash

set -e

APP_NAME=my_store
VERSION=INSECURE

#BUILD
docker compose -f ./infra/docker/docker-compose.yaml -p my_store up --detach
npx nx run-many --target=build

#TEST