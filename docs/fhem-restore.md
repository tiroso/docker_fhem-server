# fhem-restore
```
export FHEMPLATFORM="rpi" | "amd64"
export FHEMVERSION="v5.8" | "latest"
export FHEMVOLUME="fhem-server"
```
This command extract all Files from _fhem-backup.tar.bz2_ in your Home Directory to _/opt/fhem_ in your container...bzw. to your volume
```
docker run -it --rm -v ${FHEMVOLUME}:/opt/fhem -v $PWD:/backup tiroso/fhem-server:${FHEMPLATFORM}-${FHEMVERSION} fhem-restore
```
You can modify the target Backup File by settings the environment variable.

* Environment Variable
  * FILENAME
    * _userdefined-String_ (default: fhem-backup.tar.bz2)
    * Example: -e "FILENAME=otherbackup.tar.bz2"
