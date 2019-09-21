using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;


// print race timer objecs for round screens, size 240
//
class RaceTimerView240Dc
{
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
        dc.drawText(dc.getWidth() / 2, 35, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	function PrintCountdown(dc, seconds)
	{
		var countdownString = Lang.format("$1$:$2$", [(seconds / 60).format("%2d"), (seconds % 60).format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(
        	dc.getWidth() / 2 - 6, 
        	dc.getHeight() / 2 - dc.getFontHeight(Gfx.FONT_SYSTEM_NUMBER_THAI_HOT) / 2, 
        	Gfx.FONT_SYSTEM_NUMBER_THAI_HOT, countdownString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function PrintSpeed(dc, speedKnot)
	{
        var speedString = speedKnot.format("%02.1f");
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(
        	dc.getWidth() / 2, 
        	dc.getHeight() / 2 + dc.getHeight() / 5, 
        	Gfx.FONT_MEDIUM, speedString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function DrawProgress(dc, seconds)
	{
		var min = seconds / 60;
		var sec = seconds % 60;
		var secPoint = (90 - sec * 6) % 360;
		var radius = dc.getWidth() / 2;
		
		var color;
		if (min == 2 && sec > 0){ color = Gfx.COLOR_YELLOW; } else
		if ((min == 1 && sec > 0) || min == 2){ color = Gfx.COLOR_ORANGE; } else
		if (min == 0 || min == 1){ color = Gfx.COLOR_RED; } else
		{ color = Gfx.COLOR_GREEN; }
		
		dc.setColor(color, Settings.BackgroundColor);
		for (var i = 0; i < 14; i++)
		{
			dc.drawArc(radius, radius, radius - i, Gfx.ARC_COUNTER_CLOCKWISE, secPoint, 90);
		}
	}
	
	function PrintTips(dc)
	{
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(24, 88, Gfx.FONT_LARGE, "+", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(30, 132, Gfx.FONT_MEDIUM, "-", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(170, 138, Gfx.FONT_XTINY, "=", Gfx.TEXT_JUSTIFY_LEFT);
	}
}