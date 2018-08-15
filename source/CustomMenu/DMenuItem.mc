using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

// Inherit from this if you want to store additional information in the menu entry and/or change how 
// the menu is drawn - for example adding in a status icon.
// Any overridden drawing should be constrained within the items boundaries, i.e. y .. y + height / 3.
class DMenuItem
{
	const LABEL_FONT = Gfx.FONT_SMALL;
	const SELECTED_LABEL_FONT = Gfx.FONT_LARGE;
	const VALUE_FONT = Gfx.FONT_MEDIUM;
	const PAD = 0;

	var	id, label, value, userData;
	var index;		// filled in with its index, if selected
	
	// _id 		  is typically a symbol but can be anything and is just used in menu delegate to identify 
	//            which item has been selected.
	// _label	  the text to show as the item name.  Can be any object responding to toString ().
	// _value     the text to show when the item is in the selectable position.  Use null for no text
	//			  otherwise any object responding to toString () can be used.
	// _userData  optional.
	function initialize (_id, _label, _value, _userData)
	{
		id = _id;
		label = _label;
		value = _value;
		userData = _userData;
	}

	function draw (dc, y, highlight)
	{

		if (highlight)
		{
			setHighlightColor (dc);
			drawHighlightedLabel (dc, y);
		}
		else
		{
			setColor (dc);
			drawLabel (dc, y);
		}
	}
	
	function setHighlightColor (dc)
	{
		dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	}
	
	function setColor (dc)
	{
		dc.setColor (Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	}
	
	function drawLabel (dc, y)
	{
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;
		var lab = label.toString ();
		var labDims = dc.getTextDimensions (lab, LABEL_FONT);
		var yL = y + (h3 - labDims[1]) / 2;

		dc.drawText (width / 2, yL, LABEL_FONT, lab, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function drawHighlightedLabel (dc, y)
	{
		var width = dc.getWidth ();
		var h3 = dc.getHeight () / 3;
		var lab = label.toString ();
		var labDims = dc.getTextDimensions (lab, SELECTED_LABEL_FONT);
		var yL, yV, h;

		if (value != null)
		{
			// Show label and value.
			var val = value.toString ();
			var valDims = dc.getTextDimensions (val, VALUE_FONT);

			h = labDims[1] + valDims[1] + PAD;
			yL = y + (h3 - h) / 2;
			yV = yL + labDims[1] + PAD;
			dc.drawText (width / 2, yV, VALUE_FONT, val, Gfx.TEXT_JUSTIFY_CENTER);
		}
		else
		{
			yL = y + (h3 - labDims[1]) / 2;
		}
		dc.drawText (width / 2, yL, SELECTED_LABEL_FONT, lab, Gfx.TEXT_JUSTIFY_CENTER);
	}
}