using Toybox.Graphics as Gfx;
using Toybox.Application as App;

// set of permanently stored values
//
class Settings
{
	static hidden var _isWhiteBackground = false;

	static var ForegroundColor = Gfx.COLOR_WHITE;
	static var BackgroundColor = Gfx.COLOR_BLACK;

	static function LoadSettings()
	{
		_isWhiteBackground = App.getApp().getProperty("isWhiteBackground");
		setColors(_isWhiteBackground);
	}

	static function SaveSettings()
	{
		App.getApp().setProperty("isWhiteBackground", _isWhiteBackground);
	}
	
	static function PrintSome()
	{
		System.println("-- test");
	}

	static function InverseColors()
	{
		_isWhiteBackground = !_isWhiteBackground;
		setColors(_isWhiteBackground);
	}

	static hidden function setColors(isWhiteBackground)
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