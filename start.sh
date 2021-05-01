#!bin/bash
sudo apt-get install -y nginx s3fs php-fpm php-mysql mysql-client

# setup pass s3
sudo echo s3fskey > /etc/passwd-s3fs
sudo chmod 640 /etc/passwd-s3fs
sudo mkdir /var/www/pesbuk
sudo cp -R /sp2setup-master/* /var/www/pesbuk
# sudo s3fs ember-mochidaz /var/www/pesbuk/img -o passwd_file=/etc/passwd-s3fs -o url=https://s3.ap-southeast-1.amazonaws.com -ouid=1001,gid=1001,allow_other


sed -i 's/rds_end_point/db_endpoint/g' /var/www/pesbuk/config.php
sed -i 's/val_db_user/db_user/g' /var/www/pesbuk/config.php
sed -i 's/val_db_pass/db_passwd/g' /var/www/pesbuk/config.php
sed -i 's/val_db_name/db_name/g' /var/www/pesbuk/config.php


#nginx
sudo cp /sp2setup-master/pesbuk.conf /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/pesbuk.conf /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default

sudo systemctl restart nginx

#mysql
mysql -h db_endpoint -u db_user -p"db_passwd" -e "CREATE DATABASE db_name;"
mysql -h db_endpoint -u db_user -p"db_passwd" -e "GRANT ALL ON nama-db.* TO 'db_user'@'%';"
mysql -h db_endpoint -u db_user -p"db_passwd" -e "FLUSH PRIVILEGES;"
cd /var/www/website
mysql -h db_endpoint -u db_user -p"db_passwd" db_name < /var/www/pesbuk/dump.sql
