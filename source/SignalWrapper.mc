using Toybox.Attention as Attention;

// methods for signals
//
class SignalWrapper
{
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
		Attention.backlight(true);
		Attention.vibrate(_vibeBeep);
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	
	}
	
	static function Start()
	{
		Attention.vibrate(_vibeStart);
		Attention.backlight(false);
	    Attention.playTone(Attention.TONE_CANARY);
	}
	
	// never call
	//
	static function StartEnd()
	{
    	Attention.playTone(Attention.TONE_ALERT_HI);
    	Attention.vibrate(_vibeBeep);
	}
	
}
