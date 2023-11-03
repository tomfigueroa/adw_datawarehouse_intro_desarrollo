docker run -d ^
    --name mysql-adw ^
    -p 33061:3306 ^
    -e MYSQL_ROOT_PASSWORD=secret ^
    -v "%cd%/scripts:/scripts" ^
    mysql-adw