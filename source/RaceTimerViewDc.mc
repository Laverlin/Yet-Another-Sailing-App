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

	static function PrintSpeed(dc, speedKnot)
	{
        var speedString = speedKnot.format("%02.1f");
		dc.setColor(Settings.ForegroundColor, Settings.BackgroundColor);
        dc.drawText(109, 78, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	static function DrawProgress(dc, seconds)
	{
		var min = seconds / 60;
		var sec = seconds % 60;
		var secPoint = sec * 6 - 270;
		secPoint = (secPoint < 0) ? secPoint + 360 : secPoint;
		dc.setColor(Gfx.COLOR_GREEN, Settings.BackgroundColor);
		dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2, Gfx.ARC_CLOCKWISE, secPoint, 90);
		dc.setColor(Settings.BackgroundColor, Settings.BackgroundColor);
		dc.fillCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2 - 8);
	}


//dc = drawingcontext from the onUpdate(dc)
//x,y = centerpoint of circle from which to make the arc
//radius = how big
//thickness = how thick of an arc to draw
//angle = 0 (nothing) to 360 (Full circle) in degrees. If you have/use radians, you can swap to radians and remove the deg2rad conversion factor inside, but I'm a degree kind of guy :)
//offsetIn = -180 to 180 in degrees. 0 will start arc from top of screen. Depends on chosen drawing direction, -90 & CLOCKWISE starts arc at 9o'clock, 90 & CLOCKWISE starts at 3o'clock position, 180 and either direction starts from 6o'clock
//colors = array containing [arc color, background fill color(usually black), [border color]] -border color is optional, leave out for no border
//direction = either CLOCKWISE or COUNTERCLOCKWISE and determines which direction the arc will grow in
function drawArc(dc, x, y, radius, thickness, angle, offsetIn, colors, direction)
{
    var color = colors[0];
	var bg = colors[1];
	var curAngle;
    	if(angle > 0){
    		dc.setColor(color,color);
    		dc.fillCircle(x,y,radius);

		dc.setColor(bg,bg);
    		dc.fillCircle(x,y,radius-thickness);

    		if(angle < 360){
			var pts = new [33];
			pts[0] = [x,y];

			angle = 360-angle;
			var radiusClip = radius + 2;
			var offset = 90*direction+offsetIn;

			for(var i=1,dec=angle/30f; i <= 31; angle-=dec){
				curAngle = direction*(angle-offset)*deg2rad;
				pts[i] = [x+radiusClip*Math.cos(curAngle), y+radiusClip*Math.sin(curAngle)];
				i++;
			}
			pts[32] = [x,y];
			dc.setColor(bg,bg);
			dc.fillPolygon(pts);
    		}
    	}else{
    		dc.setColor(bg,bg);
    		dc.fillCircle(x,y,radius);
    	}
        if(colors.size() == 3){
    		var border = colors[2];
    		dc.setColor(border, Gfx.COLOR_TRANSPARENT);
    		dc.drawCircle(x, y, radius);
    		dc.drawCircle(x, y, radius-thickness);
    	}
    }
}