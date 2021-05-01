#!/bin/bash
sudo apt-get install -y nginx s3fs php-fpm php-mysql mysql-client

# setup pass s3
sudo echo s3fskey > /etc/passwd-s3fs
sudo chmod 640 /etc/passwd-s3fs
sudo mkdir /var/www/pesbuk/
sudo mkdir /var/www/pesbuk/img # since github doesn't store empty directory, so i create it
sleep 1
sudo cp -R /sp2setup-master/* /var/www/pesbuk
sleep 1
# sudo s3fs ember-mochidaz /var/www/pesbuk/img -o passwd_file=/etc/passwd-s3fs -o url=https://s3.ap-southeast-1.amazonaws.com -ouid=1001,gid=1001,allow_other


sed -i 's/rdsendpoint/db_endpoint/g' /var/www/pesbuk/config.php
sed -i 's/valdbuser/db_user/g' /var/www/pesbuk/config.php
sleep 1
sed -i 's/valdbpass/db_passwd/g' /var/www/pesbuk/config.php
sed -i 's/valdbname/db_name/g' /var/www/pesbuk/config.php



# setup nginx sites file
sudo cp /sp2setup-master/pesbuk.conf /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/pesbuk.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx
sleep 3
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default

sudo systemctl restart nginx

# setup mysql db
mysql -h db_endpoint -u db_user -p"db_passwd" -e "CREATE DATABASE db_name;"
mysql -h db_endpoint -u db_user -p"db_passwd" -e "GRANT ALL ON db_name.* TO 'db_user'@'%';"
mysql -h db_endpoint -u db_user -p"db_passwd" -e "FLUSH PRIVILEGES;"
mysql -h db_endpoint -u db_user -p"db_passwd" db_name < /var/www/pesbuk/dump.sql
