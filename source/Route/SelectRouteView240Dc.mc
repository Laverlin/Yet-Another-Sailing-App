using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
(:savememory)
class SelectRouteView240Dc
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
		if (errorCode == 1)
		{
			message = "Use ConnectIQ app to setup \n user id";
		} 
		else if (errorCode == -400 || errorCode == 404)
		{
			message = "Wrong user id, use \nConnectIQ app to setup \n user id";
		}
		else if (errorCode == -404)
		{
			message = "There is no routes,\n use Telegram NavGarminBot \n to upload route";
		}
		else if (errorCode == -403 || errorCode == -402)
		{
			message = "The payload is too big.\n Try to remove a few routes\n using the Telegram bot.";
		}
		else
		{
			message = "Loading Error\nCode: " + errorCode.toString();
		}
		
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 30, Gfx.FONT_XTINY, message, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	function PrintSelectedRoute(dc, selectedRouteData, selectedRouteId, routesSize)
	{
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		dc.clear();
		dc.fillRectangle(0, 0, dc.getWidth(), 30 + dc.getFontHeight(Gfx.FONT_SYSTEM_SMALL) * 2 + 5);
	    dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	dc.drawText(
    		dc.getWidth() / 2, 30, Gfx.FONT_SYSTEM_SMALL, Lang.format("Select Route\n$1$  [ $2$ ]", [selectedRouteId + 1, routesSize]), Gfx.TEXT_JUSTIFY_CENTER);
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
  		
    	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Gfx.FONT_SYSTEM_XTINY, selectedRouteData["routeName"], Gfx.TEXT_JUSTIFY_CENTER);	
    	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 30, Gfx.FONT_SYSTEM_XTINY, "Waypoints : " + selectedRouteData["waypoints"].size(), Gfx.TEXT_JUSTIFY_CENTER);	
    	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 60, Gfx.FONT_SYSTEM_XTINY, YACommon.DateJson2Short(selectedRouteData["routeDate"]), Gfx.TEXT_JUSTIFY_CENTER);
    	
    	if (selectedRouteId > 0)
    	{
    		dc.fillPolygon([[dc.getWidth() / 2, 105], [dc.getWidth() / 2 - 10, 115], [dc.getWidth() / 2 + 10, 115]]);
    	}
    	
    	if (selectedRouteId < routesSize - 1)
    	{
    		dc.fillPolygon([[dc.getWidth() / 2, 230], [dc.getWidth() / 2 - 10, 220], [dc.getWidth() / 2 + 10, 220]]);
    	}	    	 
	}
}