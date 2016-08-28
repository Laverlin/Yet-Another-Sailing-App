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

	hidden var _currentLap = new LapInfo();
	hidden var _lapArray = new [100];
	hidden var _lapSpeedSum = 0;
	hidden var _lapCount = 0;


	// Should call every GPS info change
	//
	function SetPositionInfo(positionInfo)
	{
		_positionInfo = positionInfo;
	}

	// Rturn accuracy of GPS position
	//
	function Accuracy()
	{
		return (_positionInfo != null) ? _positionInfo.accuracy : 0;
	}

	// Return current speed in knots
	// !! _positionInfo should be initialised otherwise exception will be thrown
	// !! check Accuracy before invoke
	//
	function SpeedKnot() 
	{
		_speedKnot = _positionInfo.speed.toDouble() * 1.9438444924574;
		return _speedKnot;
	}

	// Return bearing in degrees
	// !! _positionInfo should be initialised otherwise exception will be thrown
	// !! check Accuracy before invoke
	//
	function BearingDegree()
	{
       	var bearingDegree = Math.toDegrees(_positionInfo.heading);
       	return ((bearingDegree > 0) ? bearingDegree : 360 + bearingDegree);
	}
	
	// Return avg speed for last 10 seconds
	// !! Must be called just once per second !
	// !! _positionInfo should be initialised otherwise exception will be thrown
	// !! check Accuracy before invoke
    //
    function AvgSpeedKnotLast10()
    {
    	var currentSpeed = _speedKnot;
    	_avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedCounter] + currentSpeed;
    	_avgSpeedValues[_avgSpeedCounter] = currentSpeed;
    	_avgSpeedCounter = (_avgSpeedCounter + 1) % 10;    	

    	return _avgSpeedSum/10;
    }

    // Return max speed
    //
    function MaxSpeedKnot()
    {
    	var currentSpeed = _speedKnot;
    	_maxSpeed = (_maxSpeed < currentSpeed) ? currentSpeed : _maxSpeed;
    	return _maxSpeed;
    }

    // Update lap statistic. Must be called only once in a second!
    //
    function UpdateLapData()
    {
    	var currentSpeed = _speedKnot;
    	_currentLap.MaxSpeed = (_currentLap.MaxSpeed < currentSpeed) ? currentSpeed : _currentLap.MaxSpeed;
    	_lapSpeedSum = _lapSpeedSum + currentSpeed;
    	_currentLap.LapTime = _currentLap.LapTime + 1;

    	// speed in m/s, once we take data every second, it means how many meters we pass from last time.
    	//
    	_currentLap.Distance = _currentLap.Distance + _positionInfo.speed.toDouble();
    }

    // Add new lap statistic
    //
    function AddLap()
    {
    	// Since time calculated once in second, time = number of speed measurements
    	//
    	_currentLap.AvgSpeed = _lapSpeedSum / _currentLap.LapTime;
    	_lapSpeedSum = 0;

    	// convert distance to nautical miles
    	//
    	_currentLap.Distance = _currentLap.Distance / 1852;

    	_lapArray[_lapCount] = _currentLap;

    	// print lap statistic
    	//
    	Sys.println("====== lap :: " + _lapCount.toString());
    	Sys.println(Lang.format("max speed : $1$ knot", [_currentLap.MaxSpeed.format("%2.1f")]));
    	Sys.println(Lang.format("avg speed : $1$ knot", [_currentLap.AvgSpeed.format("%2.1f")]));
    	Sys.println(Lang.format("lap time  : $1$ sec, $2$", 
    		[_currentLap.LapTime.format("%02d"), SecToString(_currentLap.LapTime)]));
    	Sys.println(Lang.format("distance  : $1$ nm", [_currentLap.Distance.format("%3.2f")]));
    	var timeInHour = (_currentLap.LapTime.toDouble()/Time.Gregorian.SECONDS_PER_HOUR);
    	var distance = _currentLap.AvgSpeed * timeInHour;
    	Sys.println(Lang.format("distance2 : $1$ nm", [distance.format("%3.2f")]));

    	// new lap
    	//
    	_currentLap = new LapInfo();
    	_lapCount = _lapCount + 1;
    }

    function GetLapCount()
    {
    	return _lapCount;
    }
    
    function GetLap(lapNum)
    {
    	return _lapArray[lapNum];
    }

    // write statistic of app usage to log file
    //
    function LogAppStatistic(timeStart, timeEnd)
    {
        var timeInfo = Time.Gregorian.info(timeStart, Time.FORMAT_MEDIUM);
        var duration = timeEnd.subtract(timeStart);
        Sys.println(
            Lang.format("====== app usage data :: $1$-$2$-$3$ $4$:$5$:$6$", 
            [timeInfo.year.format("%4d"), timeInfo.month, timeInfo.day.format("%02d"),
            timeInfo.hour.format("%02d"), timeInfo.min.format("%02d"), timeInfo.sec.format("%02d")]));
        Sys.println(Lang.format("max speed : $1$ knot", [_maxSpeed.format("%2.1f")]));
        Sys.println("duration : " + SecToString(duration.value()));
    }

    // convert time in seconds to string in hh:mm:ss
    //
    function SecToString(timeInSec)
    {
        var hour = timeInSec / Time.Gregorian.SECONDS_PER_HOUR;
        var min = (timeInSec % Time.Gregorian.SECONDS_PER_HOUR) / Time.Gregorian.SECONDS_PER_MINUTE;
        var sec = (timeInSec % Time.Gregorian.SECONDS_PER_HOUR) % Time.Gregorian.SECONDS_PER_MINUTE;
        return Lang.format(
            "$1$:$2$:$3$", 
            [hour.format("%02d"), min.format("%02d"), sec.format("%02d")]);
    }
}