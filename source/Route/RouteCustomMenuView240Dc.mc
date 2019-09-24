using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Since there is no way to setup a background color in layout.xml
/// all boiler-plate code for drawing objects need to be done manually.
/// This class dedicated to hide all dirty work around dc
/// 
(:savememory)
class RouteCustomMenuView240Dc
{	
	function ClearDc(dc)
	{
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	dc.clear();
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight() / 3.5);
    	
    	dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	dc.drawText(dc.getWidth() / 2, 35, Gfx.FONT_SYSTEM_SMALL, "Menu", Gfx.TEXT_JUSTIFY_CENTER);
    	
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	dc.drawLine(0, dc.getHeight() - dc.getHeight() / 3, dc.getWidth(), dc.getHeight() - dc.getHeight() / 3);
    }
    
    function PrintActualRoute(dc, actualRoute, _currentSelection)
    {
    	var font = (_currentSelection == :start) ? Gfx.FONT_SYSTEM_SMALL : Gfx.FONT_SYSTEM_XTINY;

		//dc.drawText(120, 65, Gfx.FONT_SYSTEM_XTINY, "start", Gfx.TEXT_JUSTIFY_CENTER);
    	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 3.5 + 15, font, 
    		Lang.format("$1$\n$2$", [actualRoute["RouteName"], YACommon.DateJson2Short(actualRoute["RouteDate"])]), 
    		Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    function PrintLoadRoute(dc, _currentSelection)
    {
    	var font = (_currentSelection == :load) ? Gfx.FONT_SYSTEM_SMALL : Gfx.FONT_SYSTEM_XTINY;

    	dc.drawText(dc.getWidth() / 2, dc.getHeight() - dc.getHeight() / 3 + 20, font, "Load Routes", Gfx.TEXT_JUSTIFY_CENTER);
    }    
    
    function PrintNoRoute(dc)
    {
    	 dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_WHITE);
    	 dc.drawText(dc.getWidth(), 80, Gfx.FONT_SYSTEM_XTINY, "no active route", Gfx.TEXT_JUSTIFY_CENTER);
    }
}