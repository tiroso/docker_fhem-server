#!/usr/bin bash

set -e
cd /opt/fhem
port=7072

if [ -e "/opt/fhem/fhem.pl" ]
then
echo "Existing FHEM";
else
mv /opt/fhemorigin/* /opt/fhem;
rm /opt/fhemorigin -R;
echo 'define InstallRoutine notify global:INITIALIZED sleep 1;;delete InstallRoutine;;save;;update;;sleep 1;;shutdown' >> /opt/fhem/fhem.cfg;
perl fhem.pl -d fhem.cfg | tee /opt/fhem/log/fhem_init_start.log;

fi;



if [ "$1" = "configdb" ];
then 
echo "Starte FHEM - configDB";
perl fhem.pl configDB;
elif [ "$1" = "sonos" ];
then 
echo "Starte FHEM - Sonos";
perl /opt/fhem/FHEM/00_SONOS.pm 4711 1 1;
else
echo "Starte FHEM";
perl fhem.pl fhem.cfg;
fi;
