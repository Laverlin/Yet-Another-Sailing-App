using Toybox.Graphics as Gfx;
using Toybox.Application as App;

// set of permanently stored values
//
class Settings
{
	static hidden var _isWhiteBackground = false;

	static var ForegroundColor = Gfx.COLOR_WHITE;
	static var BackgroundColor = Gfx.COLOR_BLACK;
	static var TimerValue = 300;

	static function LoadSettings()
	{
		var value = App.getApp().getProperty("timerValue");
		SetTimerValue(value);
		_isWhiteBackground = App.getApp().getProperty("isWhiteBackground");
		setColors(_isWhiteBackground);
	}

	static function SaveSettings()
	{
		App.getApp().setProperty("isWhiteBackground", _isWhiteBackground);
		App.getApp().setProperty("timerValue", TimerValue);
	}

	static function InverseColors()
	{
		_isWhiteBackground = !_isWhiteBackground;
		setColors(_isWhiteBackground);
	}
	
	static function SetTimerValue(value)
	{
		TimerValue = (value == null) ? 300 : value;
	}

	static hidden function setColors(isWhiteBackground)
	{
		_isWhiteBackground = (isWhiteBackground == null) ? false : isWhiteBackground;
        ForegroundColor = _isWhiteBackground ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
        BackgroundColor = _isWhiteBackground ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK;
	}
}