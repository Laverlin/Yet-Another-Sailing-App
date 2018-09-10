using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
class SelectRouteViewDc
{
	function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    }

	function PrintLoadingMessage(dc)
	{
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 25, Gfx.FONT_MEDIUM, "Loading Routes...", Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	function PrintErrorMessage(dc, errorCode)
	{
		var message = "";
		if (errorCode == 404)
		{
			message = "Loading Error:\n server not found";
		}
		else if (errorCode == -400)
		{
			message = "Loading Error:\n wrong user id";
		}
		else if (errorCode == -404)
		{
			message = "There is no routes,\n use Telegram to upload route";
		}
		else
		{
			message = "Loading Error\nCode: " + errorCode.toString();
		}
		
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 30, Gfx.FONT_MEDIUM, message, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	function PrintSelectedRoute(dc, selectedRouteData, selectedRouteId, routesSize)
	{
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		dc.clear();
		dc.fillRectangle(0, 0, 240, 95);
	    dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	dc.drawText(
    		120, 30, Gfx.FONT_SYSTEM_SMALL, Lang.format("Select Route\n$1$  [ $2$ ]", [selectedRouteId + 1, routesSize]), Gfx.TEXT_JUSTIFY_CENTER);
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
  		
    	dc.drawText(120, 120, Gfx.FONT_SYSTEM_XTINY, selectedRouteData["RouteName"], Gfx.TEXT_JUSTIFY_CENTER);	
    	dc.drawText(120, 150, Gfx.FONT_SYSTEM_XTINY, "WayPoints : " + selectedRouteData["WayPoints"].size(), Gfx.TEXT_JUSTIFY_CENTER);	
    	dc.drawText(120, 180, Gfx.FONT_SYSTEM_XTINY, YACommon.DateJson2Short(selectedRouteData["RouteDate"]), Gfx.TEXT_JUSTIFY_CENTER);
    	
    	if (selectedRouteId > 0)
    	{
    		dc.fillPolygon([[120, 100], [110, 110], [130, 110]]);
    	}
    	
    	if (selectedRouteId < routesSize - 1)
    	{
    		dc.fillPolygon([[120, 230], [110, 220], [130, 220]]);
    	}	    	 
	}
}