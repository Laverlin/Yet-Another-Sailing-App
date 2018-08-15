using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class DMenu extends Ui.View
{
	var menuArray;
	var title;
	var index;

	var nextIndex;
	hidden var drawMenu;
	
	function initialize (_menuArray, _menuTitle)
	{
		menuArray = _menuArray;
		title = _menuTitle;
		index = 0;
		nextIndex = 0;
		
		View.initialize ();
	}
	
	function onShow ()
	{
		drawMenu = new DrawMenu ();
	}
	
	function onHide ()
	{
		drawMenu = null;
	}

	// Return the menuItem with the matching id.  The menu item has its index field updated
	// with the index it was found at.  Returns null if not found.
	function itemWithId (id)
	{
		for (var idx = 0; idx < menuArray.size (); idx++)
		{
			if (menuArray[idx].id == id)
			{
				menuArray[idx].index = idx;
				return menuArray[idx];
			}
		}
		return null;
	}
	
	const ANIM_TIME = 0.3;
	function updateIndex (offset)
	{
		if (menuArray.size () <= 1)
		{
			return;
		}
		
		if (offset == 1)
		{
			// Scroll down. Use 1000 as end value as cannot use 1. Scale as necessary in draw call.
			Ui.animate (drawMenu, :t, Ui.ANIM_TYPE_LINEAR, 1000, 0, ANIM_TIME, null);
		}
		else
		{
			// Scroll up.
			Ui.animate (drawMenu, :t, Ui.ANIM_TYPE_LINEAR, -1000, 0, ANIM_TIME, null);
		}
		
		nextIndex = index + offset;
		
		// Cope with a 'feature' in modulo operator not handling -ve numbers as desired.
		nextIndex = nextIndex < 0 ? menuArray.size () + nextIndex : nextIndex;
		
		nextIndex = nextIndex % menuArray.size ();
		
		Ui.requestUpdate();
		index = nextIndex;
	}
	
	function selectedItem ()
	{
		menuArray[index].index = index;
		return menuArray[index];
	}
	
	function onUpdate (dc)
	{
		var width = dc.getWidth ();
		var height = dc.getHeight ();
		
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.fillRectangle(0, 0, width, height);

		// Draw the menu items.
		drawMenu.index = index;
		drawMenu.nextIndex = nextIndex;
		drawMenu.menu = self;
		
		drawMenu.draw (dc);
		
		// Draw the decorations.
		var h3 = height / 3;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		dc.setPenWidth (2);
		dc.drawLine (0, h3, width, h3);
		dc.drawLine (0, h3 * 2, width, h3 * 2);
		
		drawArrows (dc);
	}
	
	const GAP = 5;
	const TS = 5;
	
	// The arrows are drawn with lines as polygons don't give different sized triangles depending
	// on their orientation.
	function drawArrows (dc)
	{
		var x = dc.getWidth () / 2;
		var y;

		dc.setPenWidth (1);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		
		if (nextIndex != 0)
		{
			y = GAP;
			
			for (var i = 0; i < TS; i++)
			{
				dc.drawLine (x - i, y + i, x + i + 1, y + i);
			}
		}	

		if (nextIndex != menuArray.size () - 1)
		{
			y = dc.getHeight () - TS - GAP;
			
			var d;
			for (var i = 0; i < TS; i++)
			{
				d = TS - 1 - i;
				dc.drawLine (x - d, y + i, x + d + 1, y + i);
			}
		}	
	}	
}