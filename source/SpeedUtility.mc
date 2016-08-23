

class SpeedUtility
{
	hidden var _avgSpeedIterator = 0;
	hidden var _avgSpeedSum = 0;
	hidden var _avgSpeedValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	
	// calculates avg speed for last 10 seconds
    //
    function AvgLast10(currentSpeed)
    {
    	_avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedIterator] + currentSpeed;
    	_avgSpeedValues[_avgSpeedIterator] = currentSpeed;
    	_avgSpeedIterator = (_avgSpeedIterator + 1) % 10;    	

    	return _avgSpeedSum/10;
    }
}