using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;


// set of useful static functions
//
class YALib
{

    // convert time in seconds to string in hh:mm:ss
    //
    static function SecToString(timeInSec)
    {
        var hour = timeInSec / Time.Gregorian.SECONDS_PER_HOUR;
        var min = (timeInSec % Time.Gregorian.SECONDS_PER_HOUR) / Time.Gregorian.SECONDS_PER_MINUTE;
        var sec = (timeInSec % Time.Gregorian.SECONDS_PER_HOUR) % Time.Gregorian.SECONDS_PER_MINUTE;
        return Lang.format(
            "$1$:$2$:$3$", 
            [hour.format("%02d"), min.format("%02d"), sec.format("%02d")]);
    }
}