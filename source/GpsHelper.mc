/// Helper class to work with GPS features
///
class GpsHelper
{
	hidden var _positionInfo;

	hidden var _avgSpeedIterator = 0;
	hidden var _avgSpeedSum = 0;
	hidden var _avgSpeedValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	hidden var _maxSpeed = 0;

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
		return _positionInfo.speed.toDouble() * 1.9438444924574;
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
	// !! _positionInfo should be initialised otherwise exception will be thrown
	// !! check Accuracy before invoke
    //
    function AvgSpeedKnotLast10()
    {
    	var currentSpeed = SpeedKnot();
    	_avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedIterator] + currentSpeed;
    	_avgSpeedValues[_avgSpeedIterator] = currentSpeed;
    	_avgSpeedIterator = (_avgSpeedIterator + 1) % 10;    	

    	return _avgSpeedSum/10;
    }

    // Return max speed
	// !! _positionInfo should be initialised otherwise exception will be thrown
	// !! check Accuracy before invoke    
    //
    function MaxSpeedKnot()
    {
    	var currentSpeed = SpeedKnot();
    	_maxSpeed = (_maxSpeed < currentSpeed) ? currentSpeed : _maxSpeed;
    	return _maxSpeed;
    }
}