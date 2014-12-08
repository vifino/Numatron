#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo "Updating to latest versiom..."
git pull
bundle
chmod +x numatron
chmod +x *.sh
echo "Installed dependencies."
# GeoIP Part
echo "Downloading GeoIP Databases..."
cd modules/geoip
wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz # GeoIP
gunzip GeoIP.dat.gz
wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip GeoLiteCity.dat.gz
cd ../..
echo "Done downloading."
echo "Making Named Pipes..."
mkfifo passive
mkfifo auth
cd ..
# End
echo "Done! You should be good to go now!"
echo "Remember: Tweak the settings in settings.rb to fit your needs!"
