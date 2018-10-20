using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;


// set of useful static functions
//
class YACommon
{

    // convert time in seconds to string in hh:mm:ss
    //
    static function SecToString(timeInSec)
    {
        var hour = timeInSec / Time.Gregorian.SECONDS_PER_HOUR;
        var min = (timeInSec.toLong() % Time.Gregorian.SECONDS_PER_HOUR) / Time.Gregorian.SECONDS_PER_MINUTE;
        var sec = (timeInSec.toLong() % Time.Gregorian.SECONDS_PER_HOUR) % Time.Gregorian.SECONDS_PER_MINUTE;
        return Lang.format(
            "$1$:$2$:$3$", 
            [hour.format("%02d"), min.format("%02d"), sec.format("%02d")]);
    }
    
    // return absolute number
    //
    static function Abs(x)
    {
    	return (x < 0) ? -x : x;
    }
    
    static function DateJson2Short(date)
    {
    	return Lang.format("$1$ $2$", [date.substring(0, 10), date.substring(11, 16)]);
    }
    
    function ReadKeyInt(myApp, key, defaultValue) 
    {
    	var value = myApp.getProperty(key);
    	if(value == null || !(value instanceof Number)) 
    	{
        	if(value != null) 
        	{
            	value = value.toNumber();
        	} 
        	else 
        	{
            	value = thisDefault;
        	}
    	}
    	return value;
	}	
    
    (:debug)
    static function DebugPrint(text)
    {
    	Sys.println(text);
    }
}