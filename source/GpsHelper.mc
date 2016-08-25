using Toybox.System as Sys;
using Toybox.Lang as Lang;

/// Helper class to work with GPS features
///
class GpsHelper
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
    	var currentSpeed = SpeedKnot();
    	_currentLap.MaxSpeed = (_currentLap.MaxSpeed < currentSpeed) ? currentSpeed : _currentLap.MaxSpeed;
    	_lapSpeedSum = _lapSpeedSum + currentSpeed;
    	_currentLap.LapTime = _currentLap.LapTime + 1;

    	// speed in m/s, once we take data every second, it means how many meters we pass from last time.
    	//
    	_currentLap.Distance = _positionInfo.speed.toDouble();
    }

    // Add new lap statistic
    //
    function AddLap()
    {
    	// Since time calculated once in second, time = number of speed measurements
    	//
    	_currentLap.AvgSpeed = _lapSpeedSum / _currentLap.LapTime;

    	// convert distance to nautical miles
    	//
    	_currentLap.Distance = _currentLap.Distance / 1852

    	_lapArray[_lapCount] = _currentLap;

    	// print lap statistic
    	//
    	Sys.println("====== lap :: " + _lapCount.toString());
    	Sys.println(Lang.format("max speed : $1$ knot", [_currentLap.MaxSpeed.format("%2.1f")]));
    	Sys.println(Lang.format("avg speed : $1$ knot", [_currentLap.AvgSpeed.format("%2.1f")]));
    	var hour = _currentLap.LapTime / 3600;
    	var min = (_currentLap.LapTime % 3600) / 60;
    	var sec = (_currentLap.LapTime % 3600) % 60;
    	Sys.println(Lang.format("lap time  : $1$ sec, $2$:$3$:$4$", 
    		[_currentLap.LapTime.format("%02d"), hour.format("%02d"), min.format("%02d"), sec.format("%02d")]));
    	Sys.println(Lang.format("distance  : $1$ nm", [_currentLap.Distance.format("%3.2f")]));
    	Sys.println(Lang.format("distance2 : $1$ nm", [_currentLap.AvgSpeed/(_currentLap.LapTime/3600).format("%3.2f")]));

    	// new lap
    	//
    	_currentLap = new LapInfo();
    	_lapCount = _lapCount + 1
    }

    function GetLapCount()
    {
    	return _lapCount;
    }
}