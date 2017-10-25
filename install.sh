echo "> Grabbing october"
docker run --rm -it -v $(pwd)/www:/app --workdir /app composer create-project october/october /app/october

echo "> Building all containers"
docker-compose build

echo "> Starting all containers / services"
docker-compose up -d --remove-orphans

echo "> Creating database"
# Grab the container hash for mysql and crate adatabase (only when not-yet existing...)
echo "CREATE DATABASE IF NOT EXISTS october DEFAULT CHARACTER SET utf8;" | docker exec -i $(docker-compose ps -q mysql) mysql -uroot -proot

echo "> Installing october"
docker-compose exec october php october/artisan october:install

#echo "> Cleaning up installation"
#rm -rf install_files
#rm install.php

echo "> opening browser"
open http://localhost:81
