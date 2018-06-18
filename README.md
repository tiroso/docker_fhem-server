<h1>docker_fhem-server</h1>
<h2>Create Image</h2>
<p>
  <code>docker build https://github.com/tiroso/docker_fhem-server.git#v5.8 --tag tiroso/fhem-server:v5.8 --tag tiroso/fhem-server:latest</code>
</p>
<h2>Pull Image</h2>
<p>
  I've compiled this Image on an amd64 and an arm32v6 (Raspberry Pi). Also you can pull "amd64" or "arm32v6"<br>
  <code>docker pull tiroso/fhem-server:&lt;arch&gt;-v5.8</code>
</p>
<i>Image with configDB and DBLog</i>
<h2>Create Container</h2>
<h4>Without persistent Data</h4>
<p>
  <code>docker run --restart always -d --name fhem-server -h fhem-server -e "TZ=Europe/Berlin" --publish "8083:8083" tiroso/fhem-server:<arch>-v5.8 (configdb)</code><br>
</p>
<h4>With persistent Data</h4>
<p>
  <code>docker volume create fhem-server</code><br>
  <code>docker run --restart always -d --name fhem-server -h fhem-server -v fhem-server:/opt/fhem -e "TZ=Europe/Berlin" --publish "8083:8083" tiroso/fhem-server:<arch>-v5.8 (configdb)</code><br>
</p>
<h2>Backup FHEM Server</h2>
<p>First you have to create a backup folder:<br>
  <code>mkdir $PWD/fhem-server-backup</code><br>
  Then run the backup in a seperate Docker Container based on alpine<br>
  <code>docker run -it --rm -v fhem-server:/volume -v $PWD/fhem-server-backup:/backup alpine tar -cjf /backup/$(date "+%Y%m%d%H%M%S").tar.bz2 -C /volume ./</code>
</p>
<h2>Restore FHEM Server</h2>
<p>Backup your selected backup to the volume<br>
  <code>docker run -it -v fhem-server:/volume -v $PWD/fhem-server-backup:/backup alpine sh -c "rm -rf /volume/* /volume/..?* /volume/.[!.]* ; tar -C /volume/ -xjf /backup/<your backupfile>.tar.bz2"</code>
</p>
