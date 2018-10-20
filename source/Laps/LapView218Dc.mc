using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class LapView218Dc
{	

	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    }
    
    function PrintLapsEmpty(dc)
    {
    	dc.drawText(109, 80, Gfx.FONT_MEDIUM, "There is no laps\n to display", Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    function PrintLapInfo(dc, lapInfo)
    {
    	var timeInfo = Time.Gregorian.info(lapInfo.StartTime, Time.FORMAT_MEDIUM);

        dc.drawText(109, 10, Gfx.FONT_TINY, Lang.format("lap $1$", [lapInfo.LapNumber.format("%2d")]), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 30, Gfx.FONT_TINY, Lang.format("[ $1$ $2$ $3$:$4$ ]",
             [timeInfo.day.format("%02d"), timeInfo.month, timeInfo.hour.format("%02d"), timeInfo.min.format("%02d")]), Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(34, 64, Gfx.FONT_MEDIUM, "max speed :  " + lapInfo.MaxSpeedKnot.format("%2.1f"), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(34, 94, Gfx.FONT_MEDIUM, "avg speed  :  " + lapInfo.AvgSpeedKnot.format("%2.1f"), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(34, 124, Gfx.FONT_MEDIUM, "distance    : " + lapInfo.Distance.format("%3.2f"), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(36, 154, Gfx.FONT_MEDIUM, "time  : " + YACommon.SecToString(lapInfo.Duration), Gfx.TEXT_JUSTIFY_LEFT);
    }
}