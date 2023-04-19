# kindle-touch-weather
Kindle Touch weather screensaver

1) Jailbreak the Kindle  
2) Start server on Windows (modify script for Linux)  
    $ server/start.bat  
3) Add scheduled script running  (modify crontab on Linux)  
    $ schedule/get-my-png.bat  
4) ssh to the Kindle  
5) Create empty file with name "WIFI_NO_NET_PROBE" on /base-us/, reboot Kindle  
6) Copy Kindle's part to Kindle and run them:  
    $ bash -x <full-path-to-scripts>/my-screen-saver.sh > <full-path-to-scripts>/my-screen-saver.sh.log 2>&1 &
