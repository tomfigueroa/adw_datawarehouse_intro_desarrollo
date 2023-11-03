#!/bin/bash

docker run -d \
    --name mysql-adw \
    -p 33061:3306 \
    -e MYSQL_ROOT_PASSWORD=secret \
    -v $(pwd)/scripts:/scripts \
    mysql-adw