using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;


// print race timer objecs
//
class RaceTimerViewDc
{
	static function ClearDc(dc)
	{
    	dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
    	dc.clear();
    }

	static function PrintTime(dc, time)
	{
        var timeString = Lang.format("$1$:$2$:$3$", 
            [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(109, 28, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	static function PrintCountdown(dc, seconds)
	{
		var countdownString = Lang.format("$1$:$2$", [(seconds/60).format("%2d"), (seconds%60).format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(46, 50, Gfx.FONT_SYSTEM_NUMBER_THAI_HOT, countdownString, Gfx.TEXT_JUSTIFY_LEFT);
	}

	static function PrintSpeed(dc, speedKnot)
	{
        var speedString = speedKnot.format("%02.1f");
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(109, 164, Gfx.FONT_MEDIUM, speedString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	static function DrawProgress(dc, seconds)
	{
		var min = seconds / 60;
		var sec = seconds % 60;
		var secPoint = sec * 6 - 270;
		secPoint = (secPoint < 0) ? secPoint + 360 : secPoint;
		dc.setColor(Gfx.COLOR_GREEN, Settings.BackgroundColor);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-1, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-2, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-3, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-4, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-6, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-7, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-8, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2-9, Gfx.ARC_CLOCKWISE, secPoint, 90);		
	}
}