using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.System as Sys;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class WaypointView240Dc
{
	hidden var _gpsBitmapArray = [
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_red, :locX=>125,:locY=>50}),	
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_red, :locX=>125,:locY=>50}),
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_yellow, :locX=>125,:locY=>50}),
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_yellow, :locX=>125,:locY=>50}),
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_green, :locX=>125,:locY=>50})];

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
        dc.drawText(120, 7, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
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
        dc.drawLine(0, 70, 240, 70);
		dc.drawLine(120, 70, 120, 240);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, currentWayPoint, totalWayPoints)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	
    	dc.drawText(115, 40, Gfx.FONT_XTINY, Lang.format("wp: $1$ [$2$]", [currentWayPoint, totalWayPoints]), Gfx.TEXT_JUSTIFY_RIGHT);
    	
       
       _gpsBitmapArray[gpsStatus].draw(dc);
       
    	dc.drawText(193, 38, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(205, 54, 8);
    }
    
}