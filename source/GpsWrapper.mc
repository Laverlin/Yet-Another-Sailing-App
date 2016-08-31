using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Helper class to work with GPS features
///
class GpsWrapper
{
	hidden var _positionInfo;

	hidden var _avgSpeedCounter = 0;
	hidden var _avgSpeedSum = 0;
	hidden var _avgSpeedValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	hidden var _maxSpeed = 0.0;
	hidden var _speedKnot = 0.0;
    hidden var _accuracy = 0;
    hidden var _heading = 0.0;
    hidden var _distance = 0.0;
    hidden var _duration = 0;

    hidden var _timer;
    hidden var _startTime;

	hidden var _currentLap = new LapInfo();
	hidden var _lapArray = new [100];
	hidden var _lapCount = 0;

    function initialize()
    {
        _startTime = Time.now();
        _currentLap.LapStartTime = _startTime;

        _timer = new Timer.Timer();
        _timer.start(method(:onTimer), 1000, true);
    }

    function Cleanup()
    {
        _timer.stop();
    }

    // should be called once in a second, otherwise calculation will be inaccurate
    //
    function onTimer()
    {
        _accuracy = (_positionInfo != null) ? _positionInfo.accuracy : 0;
        if (_accuracy < 1 )
        {
            return;
        }

        _speedKnot = _positionInfo.speed.toDouble() * 1.9438444924574;
        _heading = _positionInfo.heading;
        _maxSpeed = (_maxSpeed < _speedKnot) ? _speedKnot : _maxSpeed;

        _avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedCounter] + _speedKnot;
        _avgSpeedValues[_avgSpeedCounter] = _speedKnot;
        _avgSpeedCounter = (_avgSpeedCounter + 1) % 10;

        // calculate lap data
        //
        _currentLap.MaxSpeed = (_currentLap.MaxSpeed < _speedKnot) ? _speedKnot : _currentLap.MaxSpeed;        

        // since speed in m/c and we call it once in a second then distance = speed in meters
        //
        _distance = _distance + _positionInfo.speed;

        // total amount of seconds
        //
        _duration = _duration +1;
    }

	function SetPositionInfo(positionInfo)
	{
		_positionInfo = positionInfo;
	}

	// Rturn accuracy of GPS position
	//
	function Accuracy()
	{
		return _accuracy;
	}

	// Return current speed in knots
	//
	function SpeedKnot() 
	{
		return _speedKnot;
	}

	// Return bearing in degrees
	//
	function BearingDegree()
	{
       	var bearingDegree = Math.toDegrees(_heading);
       	return ((bearingDegree > 0) ? bearingDegree : 360 + bearingDegree);
	}
	
	// Return avg speed for last 10 seconds
    //
    function AvgSpeedKnotLast10()
    {
    	return _avgSpeedSum/10;
    }

    // Return max speed
    //
    function MaxSpeedKnot()
    {
    	return _maxSpeed;
    }

    // Add new lap statistic
    //
    function AddLap()
    {
        // convert distance to nautical miles
        //
        _currentLap.Distance = (_distance - _currentLap.Distance) / 1852;
        _currentLap.LapTime = (_duration - _currentLap.LapTime);
        _currentLap.AvgSpeed = _currentLap.Distance/(_currentLap.LapTime.toDouble()/Time.Gregorian.SECONDS_PER_HOUR);

    	_lapArray[_lapCount] = _currentLap;

    	// print lap statistic
    	//
    	Sys.println("====== lap :: " + _lapCount.toString());
    	Sys.println(Lang.format("max speed : $1$ knot", [_currentLap.MaxSpeed.format("%2.1f")]));
    	Sys.println(Lang.format("avg speed : $1$ knot", [_currentLap.AvgSpeed.format("%2.1f")]));
    	Sys.println(Lang.format("lap time  : $1$ sec, $2$", 
    		[_currentLap.LapTime.format("%02d"), YALib.SecToString(_currentLap.LapTime)]));
    	Sys.println(Lang.format("distance  : $1$ nm", [_currentLap.Distance.format("%3.2f")]));
    	var timeInHour = (_currentLap.LapTime.toDouble()/Time.Gregorian.SECONDS_PER_HOUR);
    	var distance = _currentLap.AvgSpeed * timeInHour;
    	Sys.println(Lang.format("distance2 : $1$ nm", [distance.format("%3.2f")]));

    	// new lap. Store some current global values to calculate difference later
    	//
        _lapCount = _lapCount + 1;
    	_currentLap = new LapInfo();
        _currentLap.LapStartTime = Time.now();
        _currentLap.Distance = _distance;        
        _currentLap.LapTime = _duration;
        _currentLap.LapNum = _lapCount;
    }

    function GetLapCount()
    {
    	return _lapCount;
    }
    
    function GetLapArray()
    {
    	return _lapArray;
    }

    // write statistic of app usage to log file
    //
    function LogAppStatistic()
    {
        var timeInfo = Time.Gregorian.info(_startTime, Time.FORMAT_MEDIUM);
        var duration = Time.now().subtract(_startTime);
        Sys.println(
            Lang.format("====== app usage data :: $1$-$2$-$3$ $4$:$5$:$6$", 
            [timeInfo.year.format("%4d"), timeInfo.month, timeInfo.day.format("%02d"),
            timeInfo.hour.format("%02d"), timeInfo.min.format("%02d"), timeInfo.sec.format("%02d")]));
        Sys.println(Lang.format("max speed : $1$ knot", [_maxSpeed.format("%2.1f")]));
        Sys.println("duration : " + YALib.SecToString(duration.value()));
        Sys.println("sec taken : " + _duration);
        Sys.println("distance : " + _distance / 1852);
        Sys.println("avg speed : " + (_distance / 1852) / (_duration.toDouble() / Time.Gregorian.SECONDS_PER_HOUR));
    }
}