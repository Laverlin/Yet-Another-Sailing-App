using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
(:savememory)
class WaypointView218Dc
{
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];	

	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    }

	function PrintTime(dc, time)
	{
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(109, 12, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(94, 108, Gfx.FONT_NUMBER_MEDIUM, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(34, 118, Gfx.FONT_XTINY, "SOG", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(94, 58, Gfx.FONT_NUMBER_MEDIUM, bearingString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(34, 68, Gfx.FONT_XTINY, "COG", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0,60,218,60);
		//dc.drawLine(0,160,218,160);
		dc.drawLine(109,60,109,218);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, lapCount)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	
    	dc.drawText(60, 38, Gfx.FONT_XTINY, Lang.format("lap: $1$",[lapCount]), Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(110, 38, Gfx.FONT_XTINY, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(170, 38, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(120, 48, 6);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(180, 48, 6);
    }
    
}