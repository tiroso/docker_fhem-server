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

if [ -e "/opt/fhem/log/fhem.log.5" ]
then
rm /opt/fhem/log/fhem.log.5;
fi;

if [ -e "/opt/fhem/log/fhem.log.4" ]
then
mv /opt/fhem/log/fhem.log.4 /opt/fhem/log/fhem.log.5;
fi;

if [ -e "/opt/fhem/log/fhem.log.3" ]
then
mv /opt/fhem/log/fhem.log.3 /opt/fhem/log/fhem.log.4;
fi;

if [ -e "/opt/fhem/log/fhem.log.2" ]
then
mv /opt/fhem/log/fhem.log.2 /opt/fhem/log/fhem.log.3;
fi;

if [ -e "/opt/fhem/log/fhem.log.1" ]
then
mv /opt/fhem/log/fhem.log.1 /opt/fhem/log/fhem.log.2;
fi;

if [ -e "/opt/fhem/log/fhem.log" ]
then
mv /opt/fhem/log/fhem.log /opt/fhem/log/fhem.log.1;
fi;

if [ "$1" = "configdb" ];
then 
echo "Starte FHEM - configDB";
perl fhem.pl configDB | tee /opt/fhem/log/fhem.log;
else
echo "Starte FHEM";
perl fhem.pl fhem.cfg | tee /opt/fhem/log/fhem.log;
fi;
