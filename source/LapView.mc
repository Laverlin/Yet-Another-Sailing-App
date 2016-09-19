using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

class LapView extends Ui.View 
{
    hidden var _lapInfo;

	function initialize(lapInfo) 
    {
        View.initialize();
        
        _lapInfo = lapInfo;
	}

    function onUpdate(dc) 
    {   
    	PrintLapInfo(dc, _lapInfo);
	}

    function PrintLapInfo(dc, lapInfo)
    {
        dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.clear();
        
        if (lapInfo == null)
        {
            dc.drawText(109, 80, Gfx.FONT_MEDIUM, "There is no laps\n to display", Gfx.TEXT_JUSTIFY_CENTER);
            return;
        }
        
        var timeInfo = Time.Gregorian.info(lapInfo.StartTime, Time.FORMAT_MEDIUM);

        dc.drawText(109, 12, Gfx.FONT_TINY, Lang.format("lap $1$", [lapInfo.LapNumber.format("%2d")]), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 24, Gfx.FONT_TINY, Lang.format("[ $1$.$2$ $3$:$4$ ]",
             [timeInfo.day.format("%02d"), timeInfo.month, timeInfo.hour.format("%02d"), timeInfo.min.format("%02d")]), Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(20, 50, Gfx.FONT_MEDIUM, "max speed : " + lapInfo.MaxSpeedKnot.format("%2.1f"), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(18, 80, Gfx.FONT_MEDIUM, "avg speed   : " + lapInfo.AvgSpeedKnot.format("%2.1f"), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(18, 110, Gfx.FONT_MEDIUM, "distance      : " + lapInfo.Distance.format("%3.2f"), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 140, Gfx.FONT_MEDIUM, "lap time : " + YACommon.SecToString(lapInfo.Duration), Gfx.TEXT_JUSTIFY_LEFT);
    }      
}