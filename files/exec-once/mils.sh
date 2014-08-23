#!/bin/bash

confDir="/etc/nginx/sites-enabled"
sudo rm $confDir/_.conf

hostType=$(/bin/grep 'type' /vagrant/.Vagrantfilerc.yaml | awk '{match($0,"type:\\s+(.*?)\\s*",a)}END{print a[1]}');

servername=$(/bin/grep server_name $confDir/* --color=none -h |  awk '{match($0,"server_name\\s+(.*?)\\s*;",a)}END{print a[1]}');
rootdir=$(/bin/grep root $confDir/* --color=none -h | awk '{match($0,"root\\s+(.*?)\\s*;",a)}END{print a[1]}' | awk '{gsub("\/", "\\\\&");print}');
fastcgipass=$(/bin/grep fastcgi_pass $confDir/* --color=none -h |  awk '{match($0,"fastcgi_pass\\s+(.*?)\\s*;",a)}END{print a[1]}');

echo $fastcgipass;
echo $rootdir;
echo $servername;

destFile="/etc/nginx/sites-available/$hostType";
sudo rm $confDir/*;

sudo cp -f /vagrant/puphpet/files/resources/nginx/vhost/$hostType $destFile && cd /etc/nginx/sites-enabled && sudo ln -s ../sites-available/$hostType; 

sudo sed -i -e "s/\${servername}/$servername/" -e "s/\${rootdir}/$rootdir/" -e "s/\${fastcgipass}/$fastcgipass/" $destFile
sudo /etc/init.d/nginx restart

if [ "$hostType" == "magento" ] 
then
    echo "Configure additional features for magento";
    cd /var/www/shell && hhvm indexer.php reindex all;
fi
