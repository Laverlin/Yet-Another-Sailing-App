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
        dc.drawText(109, 22, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}
	
	static function PrintCountdown(dc, seconds)
	{
		var countdownString = Lang.format("$1$:$2$", [(seconds/60).format("%2d"), (seconds%60).format("%02d")]);
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(46, 50, Gfx.FONT_SYSTEM_NUMBER_THAI_HOT, countdownString, Gfx.TEXT_JUSTIFY_LEFT);
	}
}