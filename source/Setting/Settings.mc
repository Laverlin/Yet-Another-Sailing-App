using Toybox.Graphics as Gfx;
using Toybox.Application as App;

// set of permanently stored values
//
class Settings
{
	enum 
	{
		Cruise,
		Route
	}
	static var ForegroundColor = Gfx.COLOR_WHITE;
	static var BackgroundColor = Gfx.COLOR_BLACK;
	static var DimColor = Gfx.COLOR_LT_GRAY;
	static var TimerValue = 300;
	static var IsTimerValueUpdated = false;
	static var IsAutoRecording = false;
	static var IsWhiteBackground = false; 
	
	static var RouteApiUrl = "";
	static var UserId = "";
	static var CurrentRoute = null;
	static var WpEpsilon = 100;

	static var TimerSuccessor = Cruise;

	static function LoadSettings()
	{
		SetAutoRecording(App.getApp().getProperty("IsAutoRecording"));
		SetTimerValue(App.getApp().getProperty("timerValue"));
		SetBackground(App.getApp().getProperty("isWhiteBackground"));
		UserId = App.getApp().getProperty("userId");
		WpEpsilon = App.getApp().getProperty("wpEpsilon");
		CurrentRoute = App.getApp().getProperty("CurrentRoute2");
		RouteApiUrl = Toybox.WatchUi.loadResource(Rez.Strings.apiUrl);
	}

	static function SaveSettings()
	{
		App.getApp().setProperty("isWhiteBackground", IsWhiteBackground);
		App.getApp().setProperty("timerValue", TimerValue);
		App.getApp().setProperty("IsAutoRecording", IsAutoRecording);
		App.getApp().setProperty("CurrentRoute", CurrentRoute);
	}

	static function SetBackground(isWhiteBackground)
	{
		IsWhiteBackground = (isWhiteBackground == null) ? false : isWhiteBackground;
        ForegroundColor = isWhiteBackground ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
        BackgroundColor = isWhiteBackground ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK;
        DimColor = isWhiteBackground ? Gfx.COLOR_DK_GRAY : Gfx.COLOR_LT_GRAY;
	}
	
	static function SetTimerValue(value)
	{
		TimerValue = (value == null) ? 300 : value;
		IsTimerValueUpdated = true;
	}
	
	static function GetTimerValue()
	{
		IsTimerValueUpdated = false; 
		return TimerValue;
	}

	static function SetAutoRecording(isAutoRecording)
	{
		IsAutoRecording = (isAutoRecording == null) ? false : isAutoRecording;
	}
}