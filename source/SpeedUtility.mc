

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

	// return current speed in knots
	//
	function CurrentSpeedKnt() 
	{
		return _positionInfo.speed.toDouble() * 1.9438444924574;
	}

	// return bearing in degrees
	//
	function BearingDegree()
	{
       	var bearingDegree = Math.toDegrees(_positionInfo.heading);
       	return ((headingDegree > 0) ? bearingDegree : 360 + bearingDegree);
	}
	
	// calculates avg speed for last 10 seconds
    //
    function AvgLast10()
    {
    	var currentSpeed = CurrentSpeedKnt();
    	_avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedIterator] + currentSpeed;
    	_avgSpeedValues[_avgSpeedIterator] = currentSpeed;
    	_avgSpeedIterator = (_avgSpeedIterator + 1) % 10;    	

    	return _avgSpeedSum/10;
    }

    // return max speed
    //
    function MaxSpeed()
    {
    	var currentSpeed = CurrentSpeedKnt();
    	_maxSpeed = (_maxSpeed < currentSpeed) ? currentSpeed : _maxSpeed;
    	return _maxSpeed;
    }
}