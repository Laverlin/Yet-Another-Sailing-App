using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.System as Sys;
using Toybox.Math as Math;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class WaypointView240Dc
{
	hidden var _gpsBitmapArray = [
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_red, :locX=>125, :locY=>58}),	
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_red, :locX=>125, :locY=>58}),
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_yellow, :locX=>125, :locY=>58}),
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_yellow, :locX=>125, :locY=>58}),
		new WatchUi.Bitmap({:rezId=>Rez.Drawables.gps_green, :locX=>125, :locY=>58})];

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
        dc.drawText(120, 17, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(110, 85, Gfx.FONT_NUMBER_MEDIUM, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(45, 100, Gfx.FONT_XTINY, "sog", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintCog(dc, cog)
    {
        var cogString = cog.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(110, 132, Gfx.FONT_NUMBER_MEDIUM, cogString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(45, 147, Gfx.FONT_XTINY, "cog", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintVmg(dc, vmg)
    {
        var vmgString = vmg.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(130, 85, Gfx.FONT_NUMBER_MEDIUM, vmgString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(200, 100, Gfx.FONT_XTINY, "vmg", Gfx.TEXT_JUSTIFY_LEFT);    
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(125, 132, Gfx.FONT_NUMBER_MEDIUM, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(200, 147, Gfx.FONT_XTINY, "cts", Gfx.TEXT_JUSTIFY_LEFT);    
    }
    
    function PrintDistance2Wp(dc, distance2wp)
    {
    	var distanceString;
    	if (distance2wp < 0.2)
    	{
    		distanceString = "." + (distance2wp * 100).format("%2d");
    	}
    	else
    	{
    		distanceString = distance2wp.format("%2.1f");
    	}
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(125, 173, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        //dc.drawText(200, 117, Gfx.FONT_XTINY, "cwp", Gfx.TEXT_JUSTIFY_LEFT); 
    }
    
    function PrintDistance2Finish(dc, distance2Finish)
    {
    	var distanceString = distance2Finish.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(125, 200, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        //dc.drawText(200, 117, Gfx.FONT_XTINY, "cwp", Gfx.TEXT_JUSTIFY_LEFT); 
    }
    
    function PrintXte(dc, xte)
    {
       	var xteString = (xte < 0.2 && xte > -0.2 && xte != 0)
       		? "." + (xte * 100).format("%2d")
       		: xte.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(115, 173, Gfx.FONT_SYSTEM_SMALL, xteString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(55, 173, Gfx.FONT_XTINY, "xte", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function PrintDistanceCovered(dc, distanceCovered)
    {
    	var distanceString = distanceCovered.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(115, 200, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
        //dc.drawText(117, 200, Gfx.FONT_XTINY, "nm", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, 75, 240, 75);
		dc.drawLine(120, 75, 120, 240);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, currentWayPoint, totalWayPoints)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	
    	dc.drawText(115, 48, Gfx.FONT_XTINY, Lang.format("wp: $1$ [$2$]", [currentWayPoint, totalWayPoints]), Gfx.TEXT_JUSTIFY_RIGHT);
    	
       
       _gpsBitmapArray[gpsStatus].draw(dc);
       
    	dc.drawText(193, 50, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(205, 64, 8);
    }
    
}