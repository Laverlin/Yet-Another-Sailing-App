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
class WaypointView240Dc
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
        dc.drawText(dc.getWidth() / 2, 20, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    function PrintSpeed(dc, speed)
    {
    	var topLine = dc.getHeight() / 3.1;
    	var y = (dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 36) ? topLine + 8 : topLine - 8;
    	
        var speedString = speed.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 4 + 15, y, Gfx.FONT_NUMBER_MEDIUM, speedString, Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(30, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 + 10, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(30, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 , _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(30, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 - 10, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintCog(dc, cog)
    {
    	var topLine = dc.getHeight() / 3.1;
    	var y = dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) + 
    		((dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 36) 
    			? topLine + 16 
    			: (dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 54) 
    				? topLine - 15
    				: (dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 57) 
                        ? topLine - 15
                        : topLine - 30); 
    
        var cogString = cog.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 4 + 15, y, Gfx.FONT_NUMBER_MEDIUM, cogString, Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(30, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 + 9, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(30, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2, _verticalSSPSB12Font, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(30, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 - 10, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintVmg(dc, vmg)
    {
    	var topLine = dc.getHeight() / 3.1;
    	var y = (dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 36) ? topLine + 8 : topLine - 8;
    	    
        var vmgString = vmg.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2 + dc.getWidth() / 4 + 5, y, Gfx.FONT_NUMBER_MEDIUM, vmgString, Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2 + 15, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 + 8, _verticalSSPSB12Font, "V", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() / 2 + 15, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 - 2, _verticalSSPSB12Font, "M", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() / 2 + 16, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 - 12, _verticalSSPSB12Font, "G", Gfx.TEXT_JUSTIFY_RIGHT);
    }
    
    function PrintBearing(dc, bearing)
    {
    	var topLine = dc.getHeight() / 3.1;
    	var y = dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) + 
    		((dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 36) 
    			? topLine + 16 
    			: (dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 54) 
    				? topLine - 15
    				: (dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) == 57) 
                        ? topLine - 15
                        : topLine - 30); 
    	    
        var bearingString = bearing.format("%003d");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	//dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2 + 24, y, Gfx.FONT_NUMBER_MEDIUM, bearingString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2 + 15, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 + 9, _verticalSSPSB12Font, "C", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() / 2 + 14, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2, _verticalSSPSB12Font, "T", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() / 2 + 15, y + dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM) / 2 - 8, _verticalSSPSB12Font, "S", Gfx.TEXT_JUSTIFY_RIGHT);    
    }
    
    function PrintDistance2Wp(dc, distance2wp)
    {
    	var y = dc.getHeight() - dc.getHeight() / 3.6;
    	var distanceString = (distance2wp < 0.2)
    		? "." + (distance2wp * 100).format("%02d")
    		: distance2wp.format("%2.1f");

    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(dc.getWidth() / 2 + 5, y, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Gfx.COLOR_YELLOW, Settings.BackgroundColor);
        dc.drawText(dc.getWidth() / 2 + 5 + dc.getTextWidthInPixels(distanceString, Gfx.FONT_SYSTEM_SMALL) + 2, y, 
       	 _verticalSSPSB12Font, "|", Gfx.TEXT_JUSTIFY_LEFT);   
    }
    
    function PrintDistance2Finish(dc, distance2Finish)
    {
    	var y = dc.getHeight() - dc.getHeight() / 3.6 + dc.getFontHeight(Gfx.FONT_SYSTEM_SMALL) - 2;
    	var distanceString = distance2Finish.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(dc.getWidth() / 2 + 5, y, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.drawText(dc.getWidth() / 2 + 5 + dc.getTextWidthInPixels(distanceString, Gfx.FONT_SYSTEM_SMALL) + 2, y, 
        	_verticalSSPSB12Font, "|", Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    function PrintXte(dc, xte)
    {
    	var y = dc.getHeight() - dc.getHeight() / 3.6;
    	xte = YACommon.Abs(xte);
    	xte = (xte * 100).toNumber().toFloat() / 100;
       	var xteString = (xte < 0.2 && xte != 0.0)
       		? "." + (xte * 100).format("%02d")
       		: xte.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2 - 5, y, Gfx.FONT_SYSTEM_SMALL, xteString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(Settings.DimColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
        	dc.getWidth() / 2 - 5 - dc.getTextWidthInPixels(xteString, Gfx.FONT_SYSTEM_SMALL) - 5,
        	y + 6, _trebuchetFont, "xte", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function PrintDistanceCovered(dc, distanceCovered)
    {
    	var y = dc.getHeight() - dc.getHeight() / 3.6 + dc.getFontHeight(Gfx.FONT_SYSTEM_SMALL) - 2;
    	var distanceString = distanceCovered.format("%2.1f");
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(dc.getWidth() / 2 - 5, y, Gfx.FONT_SYSTEM_SMALL, distanceString, Gfx.TEXT_JUSTIFY_RIGHT);
        //dc.drawText(117, 200, Gfx.FONT_XTINY, "nm", Gfx.TEXT_JUSTIFY_RIGHT); 
    }
    
    function DrawGrid(dc)
    {
    	var topLine = dc.getHeight() / 3.1;
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawLine(0, topLine, dc.getHeight(), topLine);
		dc.drawLine(dc.getWidth() / 2, topLine, dc.getWidth() / 2, dc.getHeight());
    }
    
    function DisplayState(dc, gpsStatus, recordingStatus, currentWayPoint, totalWayPoints)
    {
    	var topLine = dc.getHeight() / 3.1;
    	var timeBottom = 20 + dc.getFontHeight(Gfx.FONT_MEDIUM);
    	var ty = timeBottom + (topLine - timeBottom) / 2 - dc.getFontHeight(_trebuchetFont) /1.5;
    	
    	var strLen = 185;
    	var x = dc.getWidth() / 2 - strLen / 2 - 3;
    	
    	dc.setColor(Settings.ForegroundColor, Gfx.COLOR_TRANSPARENT);
    	
    	dc.drawText(x, ty, _trebuchetFont, Lang.format("wp: $1$ [$2$]", [currentWayPoint, totalWayPoints]), Gfx.TEXT_JUSTIFY_LEFT);
       
        dc.drawText(x + 115, ty, _trebuchetFont, "gps:", Gfx.TEXT_JUSTIFY_RIGHT);
       
    	dc.drawText(x + 171, ty, _trebuchetFont, "rec:", Gfx.TEXT_JUSTIFY_RIGHT);
    	
        dc.setColor(_gpsColorsArray[gpsStatus], Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(x + 126, ty + dc.getFontHeight(_trebuchetFont) / 2 + 1, 8);    	
        
        dc.setColor(recordingStatus ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(x + 181, ty + dc.getFontHeight(_trebuchetFont) / 2 + 1, 8);
    }
    
    function DisplayDirection2Wp(dc, heading, bearing)
    {
    	var r = dc.getWidth() / 2;
    	var h = 18;
    	var azimuth = Math.toRadians(bearing - heading - 90);
    	var x = r * Math.cos(azimuth) + r;
    	var y = r * Math.sin(azimuth) + r;
    	var x1 = (r-h) * Math.cos(azimuth - 0.0523599) + r;
    	var y1 = (r-h) * Math.sin(azimuth - 0.0523599) + r;
    	var x2 = (r-h) * Math.cos(azimuth + 0.0523599) + r;
    	var y2 = (r-h) * Math.sin(azimuth + 0.0523599) + r;
    	
    	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillPolygon([[x, y], [x1, y1], [x2, y2]]);
    }
    
}