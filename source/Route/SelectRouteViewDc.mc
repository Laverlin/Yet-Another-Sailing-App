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

	function PrintLoadingMessage(dc, message)
	{
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Gfx.FONT_MEDIUM, message, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	function PrintErrorMessage(dc, message, details)
	{
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 25, Gfx.FONT_MEDIUM, message, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 15, Gfx.FONT_MEDIUM, details, Gfx.TEXT_JUSTIFY_CENTER);
	}
}