using Toybox.Graphics as Gfx;
using Toybox.Application as App;

// set of permanently stored values
//
class Settings
{
	static var ForegroundColor = Gfx.COLOR_WHITE;
	static var BackgroundColor = Gfx.COLOR_BLACK;
	static var TimerValue = 300;
	static var IsTimerValueUpdated = false;
	static var IsAutoRecording = false;
	static var IsWhiteBackground = false;
	static var RouteApiUrl = "http://localhost:3000/garminapi";
	static var RouteListMethod = "routelist";
	static var UserId = "";

	static function LoadSettings()
	{
		SetAutoRecording(App.getApp().getProperty("IsAutoRecording"));
		SetTimerValue(App.getApp().getProperty("timerValue"));
		SetBackground(App.getApp().getProperty("isWhiteBackground"));
		UserId = App.getApp().getProperty("userId");
	}

	static function SaveSettings()
	{
		App.getApp().setProperty("isWhiteBackground", IsWhiteBackground);
		App.getApp().setProperty("timerValue", TimerValue);
		App.getApp().setProperty("IsAutoRecording", IsAutoRecording);
	}

	static function SetBackground(isWhiteBackground)
	{
		IsWhiteBackground = (isWhiteBackground == null) ? false : isWhiteBackground;
        ForegroundColor = isWhiteBackground ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
        BackgroundColor = isWhiteBackground ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK;
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