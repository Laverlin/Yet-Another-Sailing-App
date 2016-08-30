using Toybox.Graphics as Gfx;

// set of permanently stored values
//
class Settings
{
	static hidden var _isWhiteBackground = false;

	static var ForegroundColor = Gfx.COLOR_WHITE;
	static var BackgroundColor = Gfx.COLOR_BLACK;

	static function LoadSettings()
	{
		_isWhiteBackground = Application.getApp().getProperty("isWhiteBackground");
		SetColors(_isWhiteBackground);
	}

	static function SaveSettings()
	{
		Application.getApp().setProperty("isWhiteBackground", _isWhiteBackground);
	}

	static function InverseColors()
	{
		_isWhiteBackground = !_isWhiteBackground;
		SetColors(_isWhiteBackground);
	}

	static hidden function SetColors(isWhiteBackground)
	{
		if (isWhiteBackground)
        {
            ForegroundColor = Gfx.COLOR_BLACK;
            BackgroundColor = Gfx.COLOR_WHITE;
        }  
        else 
        {
			ForegroundColor = Gfx.COLOR_WHITE;
			BackgroundColor = Gfx.COLOR_BLACK;
        }
	}
}