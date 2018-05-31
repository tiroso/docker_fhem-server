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
sed -i 's/attr global logfile.*$/attr global logfile ./log/fhem-%Y-%m.log/' /opt/fhem/fhem.cfg
fi;



if [ "$1" = "configdb" ];
then 
echo "Starte FHEM - configDB";
perl fhem.pl configDB;
else
echo "Starte FHEM";
perl fhem.pl fhem.cfg;
fi;
