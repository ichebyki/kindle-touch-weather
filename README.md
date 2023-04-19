# kindle-touch-weather
Kindle Touch weather screensaver

1) Jailbreak the Kindle  
2) Start server on Windows (modify script for Linux)  
    $ `server/start.bat`  
3) Add scheduled script running  (modify crontab on Linux)  
    $ `schedule/get-my-png.bat`  
4) ssh to the Kindle  
5) Create empty file with name `WIFI_NO_NET_PROBE` in `/base-us/`  
    $ `touch /base-us/WIFI_NO_NET_PROBE`  
6) reboot Kindle  
7) Copy Kindle's part to Kindle (I copied to `~/kindle/`:  
8) Modify Kindle's scripts (path, server IP, timing)  
9) Clean the following dirs, but only one file `bg_xsmall_ss00.png`:  
  `/usr/share/blanket/screensaver/`  
  `/mnt/us/linkss/screensavers/`  
  `/mnt/us/linkss/backups/`  
  `/mnt/base-us/linkss/screensavers/`  
  `/mnt/base-us/linkss/backups/`  
10) Run screensaver:  
    $ `bash -x <full-path-to-scripts>/my-screen-saver.sh > <full-path-to-scripts>/my-screen-saver.sh.log 2>&1 &`  
