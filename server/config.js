var api_locParams = "lat=54.8523&lon=83.1060";
// or api_locParams = "q=Paris";
var api_appId = "665ba2730344f4961c677769f365ba19";
var api_lang = "ru"
var api_units = "metric"; 

var api_params = null;

// refresh time in miliseconds (default 30 mins)
var refreshTime = 30 * 60 * 1000;

// Browser in kindle paperwhite doesn't support rotation.
// You can override with this parameter 'll' and 'lr' for landscape left/right, 'up' for upside down.
//var rotation = "lr";

// You can set night mode,
// "auto" - by sunrise and sunset,
// "HH-HH - like: ""22-06", from 22:00 to 06:00
// "on" - night mode all the day :)
var night_mode = "auto";

// Timezone offset - kindle doesnt report correct local time to the kindle (always it is GMT),
// You can set custom GMT offset, in format "+08:00".
// You may need to set it again after winter/summer time change.
// Null is default
var utcOffset = "+07:00"

// cd /mnt/e/ichebyki/WORKS/STM32/kindle-weather-dashboard; python /mnt/e/ichebyki/WORKS/STM32/PyWebShot/get-my-png.py