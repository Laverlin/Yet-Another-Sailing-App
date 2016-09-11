using Toybox.Attention as Attention;
using Toybox.System as Sys;

// methods for signals
//
class SignalWrapper
{
	hidden static var _isBacklightOn = false;
	hidden static var _vibeBeep = [new Attention.VibeProfile(40, 300)];
	
	hidden static var _vibeStart = [
        new Attention.VibeProfile(  100, 100 ),
        new Attention.VibeProfile(  30, 200 ),
        new Attention.VibeProfile(  100, 400 ),
        new Attention.VibeProfile(  30, 200 ),
        new Attention.VibeProfile(  100, 400 )];
	
	static function PressButton()
	{
    	Attention.vibrate(_vibeBeep);		
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
	}
	
	static function HalfMinute()
	{
		Attention.vibrate(_vibeBeep);
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
	}
	
	static function TenSeconds(secLeft)
	{
		BacklightOn();
		Attention.vibrate(_vibeBeep);
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	
	}
	
	static function Start()
	{
		Attention.vibrate(_vibeStart);
	    Attention.playTone(Attention.TONE_CANARY);
	    BacklightOff();
	}
	
	// never call
	//
	static function StartEnd()
	{
    	Attention.playTone(Attention.TONE_ALERT_HI);
    	Attention.vibrate(_vibeBeep);
	}
	
	static function BacklightOn()
	{
		if (!_isBacklightOn)
		{
			Attention.backlight(true);
			_isBacklightOn = true;
		}
	}
	
	static function BacklightOff()
	{
		if (_isBacklightOn)
		{
			Attention.backlight(false);
			_isBacklightOn = false;
		}
	}
}
