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

	hidden var _speedKnot = 0.0;
    hidden var _accuracy = 0;
    hidden var _heading = 0.0;

    hidden var _timer;

	hidden var _currentLap = new LapInfo();
    hidden var _globalLap = new LapInfo();
	hidden var _lapArray = new [100];
	hidden var _lapCount = 0;

    function initialize()
    {
        _globalLap.LapStartTime = Time.now();
        _currentLap.LapStartTime = _globalLap.LapStartTime;

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
        _globalLap.MaxSpeed = (_globalLap.MaxSpeed < _speedKnot) ? _speedKnot : _globalLap.MaxSpeed;

        _avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedCounter] + _speedKnot;
        _avgSpeedValues[_avgSpeedCounter] = _speedKnot;
        _avgSpeedCounter = (_avgSpeedCounter + 1) % 10;

        // calculate lap data
        //
        _currentLap.MaxSpeed = (_currentLap.MaxSpeed < _speedKnot) ? _speedKnot : _currentLap.MaxSpeed;        

        // since speed in m/c and we call it once in a second then distance = speed in meters
        //
        _globalLap.Distance += _positionInfo.speed;

        // total amount of seconds
        //
        _globalLap.LapTime += 1;
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
    	return _globalLap.MaxSpeed;
    }

    // Add new lap statistic
    //
    function AddLap()
    {
        // convert distance to nautical miles
        //
        _currentLap.Distance = (_globalLap.Distance - _currentLap.Distance) / 1852;
        _currentLap.LapTime = (_globalLap.LapTime - _currentLap.LapTime);
        _currentLap.AvgSpeed = _currentLap.Distance/(_currentLap.LapTime.toDouble()/Time.Gregorian.SECONDS_PER_HOUR);

    	_lapArray[_lapCount] = _currentLap;

        LogWrapper.WriteLapStatistic(_currentLap);

    	// new lap. Store some current global values to calculate difference later
    	//
        _lapCount = _lapCount + 1;
    	_currentLap = new LapInfo();
        _currentLap.LapStartTime = Time.now();
        _currentLap.Distance = _globalLap.Distance;        
        _currentLap.LapTime = _globalLap.LapTime;
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

    function GetAppStatistic()
    {
        return _globalLap;
    }
}