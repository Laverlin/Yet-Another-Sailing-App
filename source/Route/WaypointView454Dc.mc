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
class WaypointView454Dc
{
	hidden var _gpsColorsArray = [Gfx.COLOR_RED, Gfx.COLOR_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN];	
	hidden var _trebuchetFont = Ui.loadResource(Rez.Fonts.trebuchet);
	hidden var _verticalSSPSB12Font = Ui.loadResource(Rez.Fonts.verticalSSPSB12);
    hidden var _fontBigDigits = Ui.loadResource(Rez.Fonts.bigDigits);
    hidden var _fontText = Ui.loadResource(Rez.Fonts.text);
    hidden var _fontSDigits = Ui.loadResource(Rez.Fonts.routeSDigits);
    hidden var _fontLDigits = Ui.loadResource(Rez.Fonts.routeLDigits);
    hidden var _fontHint = Ui.loadResource(Rez.Fonts.hint);
	
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
        dc.drawText(center, 23, _fontText, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(217, 118, _fontLDigits, speedString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(40, 203, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(40, 192, _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(40, 181, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintCog(dc, cog)
    {
        var cogString = cog.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(217, 208, _fontLDigits, cogString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(40, 295, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(40, 285, _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(40, 275, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintVmg(dc, vmg)
    {
        var vmgString = vmg <= -10 ? vmg.format("%2d") : vmg.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(430, 118, _fontLDigits, vmgString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(238, 203, _verticalSSPSB12Font, "V", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(238, 192, _verticalSSPSB12Font, "M", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(238, 181, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    function PrintBearing(dc, bearing)
    {
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(430, 208, _fontLDigits, bearingString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(238, 295, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(238, 285, _verticalSSPSB12Font, "T", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(238, 276, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_LEFT);    
    }
    
    function PrintDistance2Wp(dc, distance2wp)
    {
    	var distanceString = (distance2wp < 0.2)
    		? "." + (distance2wp * 100).format("%02d")
    		: distance2wp.format("%2.1f");

    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(238, 325, _fontSDigits, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Gfx.COLOR_YELLOW, Settings.BackgroundColor);
        dc.drawText(238 + dc.getTextWidthInPixels(distanceString, _fontSDigits) + 3, 325, 
       	 _verticalSSPSB12Font, "|", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintDistance2Finish(dc, distance2Finish)
    {
    	var distanceString = distance2Finish.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(238, 380, _fontSDigits, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.drawText(238 + dc.getTextWidthInPixels(distanceString, _fontSDigits) + 3, 380, 
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
        dc.drawText(213, 325, _fontSDigits, xteString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
        	213 - dc.getTextWidthInPixels(xteString, _fontSDigits) - 5,
        	325, _trebuchetFont, "xte", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function PrintDistanceCovered(dc, distanceCovered)
    {
    	var distanceString = distanceCovered.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(213, 380, _fontSDigits, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);

        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
        	213 - dc.getTextWidthInPixels(distanceString, _fontSDigits) - 5,
        	380, _trebuchetFont, "nm", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function DrawGrid(dc)
    {
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, 135, dc.getWidth(), 135);
		dc.drawLine(dc.getWidth() / 2, 135, dc.getWidth() / 2, dc.getHeight());
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, currentWayPoint, totalWayPoints)
    {    	
    	dc.setColor(Settings.DimColor, Settings.BackgroundColor);
    	dc.drawText(185, 90, _fontHint, Lang.format("wp: $1$ [$2$]", [currentWayPoint, totalWayPoints]), Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(280, 90, _fontHint, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
    	dc.drawText(360, 90, _fontHint, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
    	dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(290, 111, 8);
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(370, 111, 8);
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