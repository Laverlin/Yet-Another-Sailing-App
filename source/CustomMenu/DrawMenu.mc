using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

// Done as a class so it can be animated.
class DrawMenu extends Ui.Drawable
{
	const TITLE_FONT = Gfx.FONT_SMALL;

	var t = 0;				// 'time' in the animation cycle 0...1000 or -1000...0.
	var index, nextIndex, menu;
			
	function initialize ()
	{
		Drawable.initialize ({});
	}
	
	function draw (dc)
	{
		var width = dc.getWidth ();
		var height = dc.getHeight ();
		var h3 = height / 3;
		var items = menu.menuArray.size ();
		
		nextIndex = menu.nextIndex;

		// y for the middle of the three items.  
		var y = h3 + (t / 1000.0) * h3;
		
		// Depending on where we are in the menu and in the animation some of 
		// these will be unnecessary but it is easier to draw everything and
		// rely on clipping to avoid unnecessary drawing calls.
		drawTitle (dc, y - nextIndex * h3 - h3);
		for (var i = -2; i < 3; i++)
		{
			drawItem (dc, nextIndex + i, y + h3 * i, i == 0);
		}
	}
	
	function drawTitle (dc, y)
	{		
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;

		// Check if any of the title is visible., 
		if (y < -h3)
		{
			return;
		}

        dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.fillRectangle (0, y, width, h3);

		if (menu.title != null)
		{
			var dims = dc.getTextDimensions (menu.title, TITLE_FONT);
			var h = (h3 - dims[1]) / 2;
			dc.setColor (Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			dc.drawText (width / 2, y + h, TITLE_FONT, menu.title, Gfx.TEXT_JUSTIFY_CENTER);
		}
	}
	
	// highlight is the selected menu item that can optionally show a value.
	function drawItem (dc, idx, y, highlight)
	{
		var h3 = dc.getHeight () / 3;

		// Cannot see item if it doesn't exist or will not be visible.
		if (idx < 0 || idx >= menu.menuArray.size () || 
			menu.menuArray[idx] == null || y > dc.getHeight () || y < -h3)
		{
			return;
		}
		
		menu.menuArray[idx].draw (dc, y, highlight);
	}
}