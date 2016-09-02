using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

/// Helper class to work with GPS features
///
class GpsWrapper
{
    hidden var _lastTimeCall = 0l;

    // avg for 10 sec. values
    //
	hidden var _avgSpeedCounter = 0;
	hidden var _avgSpeedSum = 0;
	hidden var _avgSpeedValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    // actual gps values
    //
	hidden var _speedKnot = 0.0;
    hidden var _accuracy = 0;
    hidden var _heading = 0.0;

    // global values
    //
    hidden var _startTime;
    hidden var _distance = 0;
    hidden var _duration = 0;
    hidden var _maxSpeedKnot = 0;

    // lap values
    //
	hidden var _currentLap = new LapInfo();
	hidden var _lapArray = new [100];
	hidden var _lapCount = 0;

    function initialize()
    {
        _startTime = Time.now();
        _currentLap.LapStartTime = _startTime;
    }

	function SetPositionInfo(positionInfo)
	{
        _accuracy = (positionInfo != null) ? positionInfo.accuracy : 0;
        if (_accuracy < 1 )
        {
            return;
        }

        // difference between two method's calls 
        //
        var timeCall = Sys.getTimer();
        var timelaps = (_lastTimeCall > 0) ? timeCall - _lastTimeCall : 0;
        _lastTimeCall = timeCall;

        _speedKnot = positionInfo.speed.toDouble() * 1.9438444924574;
        _heading = positionInfo.heading;
        _maxSpeedKnot = (_maxSpeedKnot < _speedKnot) ? _speedKnot : _maxSpeedKnot;

        _avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedCounter] + _speedKnot;
        _avgSpeedValues[_avgSpeedCounter] = _speedKnot;
        _avgSpeedCounter = (_avgSpeedCounter + 1) % 10;

        _currentLap.MaxSpeed = (_currentLap.MaxSpeed < _speedKnot) ? _speedKnot : _currentLap.MaxSpeed;

        var timelapsSecond = timelaps.toDouble()/1000;
        _distance += positionInfo.speed * timelapsSecond;
        _duration += timelapsSecond;
	}

    function GetGpsInfo()
    {
        var bearingDegree = Math.toDegrees(_heading);

        var gpsInfo = new GpsInfo();
        gpsInfo.Accuracy = _accuracy;
        gpsInfo.SpeedKnot = _speedKnot;
        gpsInfo.BearingDegree = ((bearingDegree > 0) ? bearingDegree : 360 + bearingDegree);
        gpsInfo.AvgSpeedKnot = _avgSpeedSum/10;
        gpsInfo.MaxSpeedKnot = _maxSpeedKnot;
        gpsInfo.LapCount = _lapCount;

        return gpsInfo;
    }

    // Add new lap statistic
    //
    function AddLap()
    {
        // convert distance to nautical miles
        //
        _currentLap.Distance = (_distance - _currentLap.Distance) / 1852;
        _currentLap.LapTime = (_duration - _currentLap.LapTime);
        _currentLap.AvgSpeed = (_currentLap.LapTime > 0)
        	? _currentLap.Distance/(_currentLap.LapTime.toDouble()/Time.Gregorian.SECONDS_PER_HOUR)
        	: 0;

    	_lapArray[_lapCount] = _currentLap;

        LogWrapper.WriteLapStatistic(_currentLap);

    	// new lap. Store some current global values to calculate difference later
    	//
        _lapCount = _lapCount + 1;
    	_currentLap = new LapInfo();
        _currentLap.LapStartTime = Time.now();
        _currentLap.Distance = _distance;        
        _currentLap.LapTime = _duration;
        _currentLap.LapNum = _lapCount;
    }

    function GetLapArray()
    {
    	return _lapArray;
    }

    function GetAppStatistic()
    {
        var overall = new lapInfo();
        overall.LapStartTime = _startTime;
        overall.MaxSpeed = _maxSpeedKnot;
        overall.Distance = _distance / 1852;
        overall.LapTime = _duration;
        overall.AvgSpeed =  (_duration > 0) ? _distance / (_duration.toDouble() / Time.Gregorian.SECONDS_PER_HOUR) : 0;
        return overall;
    }
}