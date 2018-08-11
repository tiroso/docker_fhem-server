# docker_fhem-server
## Preparations for your FHEM Server
First of all...Lets set some environment variables to make the copy&paste simple and quick (on host)
you can choose by:
```
export FHEMPLATFORM="rpi" | "amd64"
export FHEMVERSION="v5.8" | "latest"
export FHEMVOLUME="fhem-server"
```
To make your data persistent you have to create a volume for the fhem-server.
```
docker volume create ${FHEMVOLUME}
```
If you __never__ started a FHEM Server before you have to run an Init Start. This takes a little time to update the FHEM Installation to the newest Update
```
docker run --rm -v ${FHEMVOLUME}:/opt/fhem tiroso/fhem-server:${FHEMPLATFORM}-${FHEMVERSION} fhem-init
```
If you want to run configDB instead of fhem.cfg you could modify the configDB.conf. For the default settings there is created an empty SQLite Dbase.. Use this command to edit configdb.conf
```
docker run --rm -it -v ${FHEMVOLUME}:/opt/fhem tiroso/fhem-server:${FHEMPLATFORM}-${FHEMVERSION} fhem-conf-configdb
```
if you __never__ run FHEM with configDB before you have to run a migration from fhem.cfg to configDB. __Do not run__ this command if you have a running dbase.
```
docker run --rm -it -v ${FHEMVOLUME}:/opt/fhem tiroso/fhem-server:${FHEMPLATFORM}-${FHEMVERSION} fhem-configdb-migrate
```
### Running
Now you can run the FHEM-Server.
To run _configDB_ or _fhem.cfg_ you can change an environment var. Without an env var the FHEM-Server will be started with fhem-cfg.
* FHEMMODE=FHEMCFG
* FHEMMODE=CONFIGDB
```
 docker run --restart always -d --name fhem-server -h fhem-server -e "FHEMMODE=FHEMCFG" -v ${FHEMVOLUME}:/opt/fhem -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro -p "8083:8083" tiroso/fhem-server:${FHEMPLATFORM}-${FHEMVERSION} fhem-run
 ```
## Backup FHEM Server
This command will create a backup _fhem-backup.tar.bz2_ in your Home Directory
```
docker run -it --rm -v ${FHEMVOLUME}:/opt/fhem -v $PWD:/backup tiroso/fhem-server:${FHEMPLATFORM}-${FHEMVERSION} fhem-backup
```
## Restore FHEM Server
This command extract all Files from _fhem-backup.tar.bz2_ in your Home Directory to _/opt/fhem_ in your container...bzw. to your volume
```
docker run -it --rm -v ${FHEMVOLUME}:/opt/fhem -v $PWD:/backup tiroso/fhem-server:${FHEMPLATFORM}-${FHEMVERSION} fhem-restore
```
For further information visit [my github repository](https://github.com/tiroso/docker_fhem-server)
