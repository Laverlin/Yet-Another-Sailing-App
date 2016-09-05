using Toybox.Attention as Attention;

// methods for signals
//
class SignalWrapper
{
	static function PressButton()
	{
		var vibe = [new Attention.VibeProfile(30, 300)];
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	Attention.vibrate(vibe);
	}
}
