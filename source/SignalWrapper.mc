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

	hidden static function _play(tone) 
	{
		if (!(Attention has :playTone)) 
		{
			return;
		}

		var tones = 
		[	
			Attention.TONE_LOUD_BEEP,
			Attention.TONE_CANARY,
			Attention.TONE_ALERT_HI,
		];
		Attention.playTone(tones[tone]);
	}
	

	
	static function PressButton()
	{
    	_play(0);
	}
	
	static function HalfMinute()
	{
		Attention.vibrate(_vibeBeep);
    	_play(0);
	}
	
	static function TenSeconds(secLeft)
	{
		BacklightOn();
		Attention.vibrate(_vibeBeep);
    	_play(0);
    	
	}
	
	static function Start()
	{
		Attention.vibrate(_vibeStart);
	    _play(1);
	    BacklightOff();
	}
	
	// never call
	//
	static function StartEnd()
	{
    	_play(2);
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
