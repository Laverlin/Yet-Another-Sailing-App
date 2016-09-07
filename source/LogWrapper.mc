using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

// functions to write stuff to log file
//
class LogWrapper
{
	static function WriteLapStatistic(lapInfo)
	{
    	Sys.println(Lang.format("====== lap :: ", [lapInfo.format("%02d")]));
    	Sys.println(Lang.format("max speed : $1$ knot", [lapInfo.MaxSpeedKnot.format("%2.1f")]));
    	Sys.println(Lang.format("avg speed : $1$ knot", [lapInfo.AvgSpeedKnot.format("%2.1f")]));
    	Sys.println(Lang.format("lap time  : $1$ sec, $2$", 
    		[lapInfo.Duration.format("%02d"), YACommon.SecToString(lapInfo.Duration)]));
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
        var duration = endTime.subtract(lapInfo.StartTime);

		var endTimeInfo = Time.Gregorian.info(endTime, Time.FORMAT_MEDIUM);
        Sys.println(
        	Lang.format("======= end :: $1$:$2$:$3$", 
        	[endTimeInfo.hour.format("%02d"), endTimeInfo.min.format("%02d"), endTimeInfo.sec.format("%02d")]));
        	
        Sys.println(Lang.format("max speed : $1$ knot", [lapInfo.MaxSpeedKnot.format("%2.1f")]));
        Sys.println("duration : " + YACommon.SecToString(duration.value()));
        Sys.println("distance : " + lapInfo.Distance);
        Sys.println("avg speed : " + lapInfo.AvgSpeedKnot);
    }
}