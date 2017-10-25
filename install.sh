echo "> Cloning repo"
git clone git@github.com:bashilbers/october-docker-quickstart
cd october-docker-quickstart

echo "> Building all containers"
docker-compose build

echo "> Starting all containers / services"
docker-compose up -d --remove-orphans

echo "> Creating database"
# Grab the container hash for mysql and crate adatabase (only when not-yet existing...)
echo "CREATE DATABASE IF NOT EXISTS october DEFAULT CHARACTER SET utf8;" | docker exec -i $(docker-compose ps -q mysql) mysql -uroot -proot

echo "> installing october"
docker run --rm -it -v $(pwd):/app --workdir /app composer create-project october/october www
docker-compose exec october php artisan october:install

#echo "> Cleaning up installation"
#rm -rf install_files
#rm install.php

echo "> opening browser"
open http://localhost:81
