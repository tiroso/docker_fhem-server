# docker_fhem-server</h1>
## Build Image</h2>
```
docker build https://github.com/tiroso/docker_fhem-server.git#v5.8 --tag tiroso/fhem-server:v5.8 --tag tiroso/fhem-server:v5.8
```
## Pull Image
I've compiled this Image on an amd64 and Raspberry Pi. Also you can pull "amd64" or "rpi"
```
docker pull tiroso/fhem-server:(rpi|amd64)-(v5.8|latest)
```
## Create Container
#### Without persistent Data
```
docker run --restart always -d --name fhem-server -h fhem-server -e "TZ=Europe/Berlin" --publish "8083:8083" tiroso/fhem-server:<arch>-v5.8 (configdb)
```
#### With persistent Data
```
docker volume create fhem-server
 docker run --restart always -d --name fhem-server -h fhem-server -v fhem-server:/opt/fhem -e "TZ=Europe/Berlin" --publish "8083:8083" tiroso/fhem-server:(rpi|amd64)-(v5.8|latest) (configdb)
 ```
If you set up your Server with persistent Data, it is actually as you updated it. For the first time you started the Container and you have no data it creates an Up to Date FHEM Server.

If you start the container with configdb as CMD it starts the first time with the sqlite database. You can edit the /opt/fhem/configDB.conf or /opt/fhem/logDB.conf for other databases. Restart the container...and you have the new database. 

If you want to migrate from fhem.cfg to configdb you have to start the container without further commands. Then you can set a "configdb migrate" and the Server migrates your Data to the database you specify in your configDB.conf
## Backup FHEM Server
First you have to create a backup folder:
```
mkdir $PWD/fhem-server-backup
```
Then run the backup in a seperate Docker Container based on alpine<br>
```
docker run -it --rm -v fhem-server:/volume -v $PWD/fhem-server-backup:/backup alpine tar -cjf /backup/backup.tar.bz2 -C /volume ./
```
Restore FHEM Server
Backup your selected backup to the volume
```
docker run -it -v fhem-server:/volume -v $PWD/fhem-server-backup:/backup alpine sh -c "rm -rf /volume/* /volume/..?* /volume/.[!.]* ; tar -C /volume/ -xjf /backup/backup.tar.bz2"
```
For further information visit [my github repository](https://github.com/tiroso/docker_fhem-server)
