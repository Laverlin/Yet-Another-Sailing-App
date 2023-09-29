using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class LapView454Dc
{	
    hidden var _fontText = Ui.loadResource(Rez.Fonts.text);

	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
        dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    }
    
    function PrintLapsEmpty(dc)
    {
    	dc.drawText(
    		dc.getWidth() / 2, 
    		(dc.getHeight() / 2) - dc.getFontHeight(_fontText) - 2, 
    		_fontText, "There is no laps\n to display", Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    function PrintLapInfo(dc, lapInfo)
    {
    	var timeInfo = Time.Gregorian.info(lapInfo.StartTime, Time.FORMAT_MEDIUM);
        var mid = dc.getHeight() / 2;

        dc.drawText(dc.getWidth() / 2, 10, _fontText, Lang.format("lap $1$", [lapInfo.LapNumber.format("%2d")]), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 56, _fontText, Lang.format("[ $1$ $2$ $3$:$4$ ]",
             [timeInfo.day.format("%02d"), timeInfo.month, timeInfo.hour.format("%02d"), timeInfo.min.format("%02d")]), Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(mid, 150, _fontText, "max speed :  " + lapInfo.MaxSpeedKnot.format("%2.1f"), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(mid, 200, _fontText, "avg speed :  " + lapInfo.AvgSpeedKnot.format("%2.1f"), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(mid, 250, _fontText, "distance  :  " + lapInfo.Distance.format("%3.2f"), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(mid, 300, _fontText, "time  :  " + YACommon.SecToString(lapInfo.Duration), Gfx.TEXT_JUSTIFY_CENTER);
    }
}