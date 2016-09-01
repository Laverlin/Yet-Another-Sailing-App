using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

// functions to write stuff to log file
//
class LogWrapper
{
	static function WriteLapStatistic(lapInfo)
	{
    	Sys.println("====== lap :: " + lapInfo.format("%02d"));
    	Sys.println(Lang.format("max speed : $1$ knot", [lapInfo.MaxSpeed.format("%2.1f")]));
    	Sys.println(Lang.format("avg speed : $1$ knot", [lapInfo.AvgSpeed.format("%2.1f")]));
    	Sys.println(Lang.format("lap time  : $1$ sec, $2$", 
    		[lapInfo.LapTime.format("%02d"), YALib.SecToString(lapInfo.LapTime)]));
    	Sys.println(Lang.format("distance  : $1$ nm", [lapInfo.Distance.format("%3.2f")]));
	}

	static function WriteAppStart(startTime)
	{
		var timeInfo = Time.Gregorian.info(startTime, Time.FORMAT_MEDIUM);
		Sys.println(
            Lang.format("====== app start :: $1$-$2$-$3$ $4$:$5$:$6$", 
            [timeInfo.year.format("%4d"), timeInfo.month, timeInfo.day.format("%02d"),
            timeInfo.hour.format("%02d"), timeInfo.min.format("%02d"), timeInfo.sec.format("%02d")]));		
	}

	static function WriteAppStatistic(lapInfo, endTime)
    {
        var duration = endTime.subtract(_startTime);

        Sys.println(Lang.format("max speed : $1$ knot", [lapInfo.MaxSpeed.format("%2.1f")]));
        Sys.println("duration : " + YALib.SecToString(duration.value()));
        //Sys.println("sec taken : " + _duration);
        Sys.println("distance : " + lapInfo.Distance);
        Sys.println("avg speed : " + lapInfo.AvgSpeed);

        Sys.println(
        	Lang.format("======= end :: $1$:$2$:$3$", 
        	[endTime.hour.format("%02d"), endTime.min.format("%02d"), endTime.sec.format("%02d")]));
    }
}