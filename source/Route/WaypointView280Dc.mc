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
class WaypointView280Dc
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
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(140, 13, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(33, 65, Gfx.FONT_NUMBER_MEDIUM, speedString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(26, 113, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(26, 103, _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(26, 93, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintCog(dc, cog)
    {
        var cogString = cog.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(33, 118, Gfx.FONT_NUMBER_MEDIUM, cogString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(26, 167, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(26, 157, _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(26, 147, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintVmg(dc, vmg)
    {
        var vmgString = vmg.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(165, 65, Gfx.FONT_NUMBER_MEDIUM, vmgString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(157, 111, _verticalSSPSB12Font, "V", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(157, 101, _verticalSSPSB12Font, "M", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(158, 91, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(165, 118, Gfx.FONT_NUMBER_MEDIUM, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(157, 165, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(156, 156, _verticalSSPSB12Font, "T", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(157, 148, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintDistance2Wp(dc, distance2wp)
    {
    	var distanceString = (distance2wp < 0.2)
    		? "." + (distance2wp * 100).format("%02d")
    		: distance2wp.format("%2.1f");

    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(145, 188, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Gfx.COLOR_YELLOW, Settings.BackgroundColor);
        dc.drawText(145 + dc.getTextWidthInPixels(distanceString, Gfx.FONT_SYSTEM_SMALL) + 2, 188, 
       	 _verticalSSPSB12Font, "|", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintDistance2Finish(dc, distance2Finish)
    {
    	var distanceString = distance2Finish.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(145, 221, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.drawText(145 + dc.getTextWidthInPixels(distanceString, Gfx.FONT_SYSTEM_SMALL) + 2, 221, 
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
        dc.drawText(135, 188, Gfx.FONT_SYSTEM_SMALL, xteString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
        	135 - dc.getTextWidthInPixels(xteString, Gfx.FONT_SYSTEM_SMALL) - 5,
        	198, _trebuchetFont, "xte", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function PrintDistanceCovered(dc, distanceCovered)
    {
    	var distanceString = distanceCovered.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(135, 221, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
        //dc.drawText(117, 200, Gfx.FONT_XTINY, "nm", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, 75, 280, 75);
		dc.drawLine(140, 75, 140, 280);
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, currentWayPoint, totalWayPoints)
    {
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	
    	dc.drawText(42, 49, _trebuchetFont, Lang.format("wp: $1$ [$2$]", [currentWayPoint, totalWayPoints]), Gfx.TEXT_JUSTIFY_LEFT);
       
        dc.drawText(162, 49, _trebuchetFont, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
       
    	dc.drawText(217, 49, _trebuchetFont, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
        dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(173, 61, 8);    	
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(228, 61, 8);
    }
    
    function DisplayDirection2Wp(dc, heading, bearing)
    {
    	var azimuth = Math.toRadians(bearing - heading - 90);
    	var x = 140 * Math.cos(azimuth) + 140;
    	var y = 140 * Math.sin(azimuth) + 140;
    	var x1 = 120 * Math.cos(azimuth - 0.0523599) + 140;
    	var y1 = 120 * Math.sin(azimuth - 0.0523599) + 140;
    	var x2 = 120 * Math.cos(azimuth + 0.0523599) + 140;
    	var y2 = 120 * Math.sin(azimuth + 0.0523599) + 140;
    	
    	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillPolygon([[x, y], [x1, y1], [x2, y2]]);
    }
    
}