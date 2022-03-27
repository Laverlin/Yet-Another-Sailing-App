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
(:savememory)
class WaypointView416Dc
{
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];	
	hidden var _trebuchetFont = Ui.loadResource(Rez.Fonts.trebuchet);
	hidden var _verticalSSPSB12Font = Ui.loadResource(Rez.Fonts.verticalSSPSB12);
	
	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    }

	function PrintTime(dc, time)
	{
        var center = dc.getWidth() / 2;
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(center, 23, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(68, 115, Gfx.FONT_NUMBER_MEDIUM, speedString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(55, 188, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(55, 177, _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(55, 166, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintCog(dc, cog)
    {
        var cogString = cog.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(68, 194, Gfx.FONT_NUMBER_MEDIUM, cogString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(55, 266, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(55, 255, _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(55, 244, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintVmg(dc, vmg)
    {
        var vmgString = vmg.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(238, 115, Gfx.FONT_NUMBER_MEDIUM, vmgString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(218, 187, _verticalSSPSB12Font, "V", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(218, 176, _verticalSSPSB12Font, "M", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(218, 165, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(238, 194, Gfx.FONT_NUMBER_MEDIUM, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(218, 265, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(218, 255, _verticalSSPSB12Font, "T", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(218, 246, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_LEFT);    
    }
    
    function PrintDistance2Wp(dc, distance2wp)
    {
    	var distanceString = (distance2wp < 0.2)
    		? "." + (distance2wp * 100).format("%02d")
    		: distance2wp.format("%2.1f");

    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(218, 300, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Gfx.COLOR_YELLOW, Settings.BackgroundColor);
        dc.drawText(218 + dc.getTextWidthInPixels(distanceString, Gfx.FONT_SYSTEM_SMALL) + 3, 300, 
       	 _verticalSSPSB12Font, "|", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintDistance2Finish(dc, distance2Finish)
    {
    	var distanceString = distance2Finish.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(218, 345, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.drawText(218 + dc.getTextWidthInPixels(distanceString, Gfx.FONT_SYSTEM_SMALL) + 3, 345, 
        	_verticalSSPSB12Font, "|", Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    function PrintXte(dc, xte)
    {
    	xte = YACommon.Abs(xte);
    	xte = (xte * 100).toNumber().toFloat() / 100;
       	var xteString = (xte < 0.2 && xte != 0.0)
       		? "." + (xte * 100).format("%02d")
       		: xte.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(198, 300, Gfx.FONT_SYSTEM_SMALL, xteString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
        	198 - dc.getTextWidthInPixels(xteString, Gfx.FONT_SYSTEM_SMALL) - 5,
        	300, _trebuchetFont, "xte", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function PrintDistanceCovered(dc, distanceCovered)
    {
    	var distanceString = distanceCovered.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(198, 345, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, 120, dc.getWidth(), 120);
		dc.drawLine(dc.getWidth() / 2, 120, dc.getWidth() / 2, dc.getHeight());
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, currentWayPoint, totalWayPoints)
    {    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
    	dc.drawText(145, 80, Gfx.FONT_XTINY, Lang.format("wp: $1$ [$2$]", [currentWayPoint, totalWayPoints]), Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(265, 80, Gfx.FONT_XTINY, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(345, 80, Gfx.FONT_XTINY, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(280, 98, 8);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(360, 98, 8);
    }
    
    function DisplayDirection2Wp(dc, heading, bearing)
    {
        var radius = dc.getWidth() / 2;

    	var azimuth = Math.toRadians(bearing - heading - 90);
    	var x = radius * Math.cos(azimuth) + radius;
    	var y = radius * Math.sin(azimuth) + radius;
    	var x1 = (radius - 20) * Math.cos(azimuth - 0.0523599) + radius;
    	var y1 = (radius - 20) * Math.sin(azimuth - 0.0523599) + radius;
    	var x2 = (radius - 20) * Math.cos(azimuth + 0.0523599) + radius;
    	var y2 = (radius - 20) * Math.sin(azimuth + 0.0523599) + radius;
    	
    	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillPolygon([[x, y], [x1, y1], [x2, y2]]);
    }
    
}