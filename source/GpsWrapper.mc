using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.ActivityRecording as Fit;

/// Helper class to work with GPS features
///
class GpsWrapper
{
    hidden var _lastTimeCall = 0l;
    hidden var _activeSession;
    hidden var _isAutoRecordStart = false;

    // avg for 10 sec. values (speed)
    //
	hidden var _avgSpeedIterator = 0;
	hidden var _avgSpeedSum = 0;
	hidden var _avgSpeedValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	
	// max for3 sec. values (speed)
    //
	hidden var _maxSpeedIterator = 0;
	hidden var _maxSpeedSum = 0;
	hidden var _maxSpeedValues = [0, 0, 0];

    // avg for 10 sec. values (bearing)
    //
    hidden var _avgSinValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    hidden var _avgCosValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    hidden var _sinBearingSum = 0;
    hidden var _cosBearingSum = 0;
    hidden var _avgBearingDegree = 0;
    hidden var _avgBearingIterator = 0;

    // actual gps values
    //
	hidden var _speedKnot = 0.0;
    hidden var _accuracy = 0;
    hidden var _bearingDegree = 0;
    hidden var _location = null;

    // global values
    //
    hidden var _startTime;
    hidden var _distance = 0;
    hidden var _duration = 0;
    hidden var _maxSpeedKnot = 0;

    // lap values
    //
	hidden var _currentLap = new LapInfo();
	hidden var _lapArray = new [0];
	hidden var _lapCount = 0;

    const LAP_ARRAY_MAX = 20;
    const MAX_SPEED_INTERVAL = 3;
    const AVG_SPEED_INTERVAL = 10;
    const AVG_BEARING_INTERVAL = 10;
    const METERS_PER_NAUTICAL_MILE = 1852;
    const MS_TO_KNOT = 1.9438444924574;

    function initialize()
    {
        var deviceSettings = Sys.getDeviceSettings();

        if(deviceSettings.monkeyVersion[0] >= 3) {
            _activeSession = Fit.createSession({:name => "Sailing", :sport => Fit.SPORT_SAILING});    
        } else {
            _activeSession = Fit.createSession({:name => "Sailing", :sport => Fit.SPORT_GENERIC});
        }
        
    }

	function SetPositionInfo(positionInfo)
	{
        _accuracy = (positionInfo != null) ? positionInfo.accuracy : 0;
        if (_accuracy < 1 )
        {
            return;
        }

        // autostart recording 
        //
        if (!_isAutoRecordStart && Settings.IsAutoRecording)
        {
        	_isAutoRecordStart = StartStopRecording();
        }

        // difference between two method's calls 
        //
        var timeCall = Sys.getTimer();
        var timelaps = (_lastTimeCall > 0) ? timeCall - _lastTimeCall : 0;
        _lastTimeCall = timeCall;

        _speedKnot = positionInfo.speed.toDouble() * MS_TO_KNOT;
        _bearingDegree = (Math.toDegrees(positionInfo.heading) + 360).toNumber() % 360;

		// moving max speed : in order to avoid fluctuation, max speed take as avg from 3 values
		//
		_maxSpeedSum = _maxSpeedSum - _maxSpeedValues[_maxSpeedIterator] + _speedKnot;
        _maxSpeedValues[_maxSpeedIterator] = _speedKnot;
        _maxSpeedIterator = (_maxSpeedIterator + 1) % MAX_SPEED_INTERVAL;
        var maxSpeed = _maxSpeedSum / MAX_SPEED_INTERVAL;
        _maxSpeedKnot = (_maxSpeedKnot < maxSpeed) ? maxSpeed : _maxSpeedKnot;
		_currentLap.MaxSpeedKnot = (_currentLap.MaxSpeedKnot < maxSpeed) ? maxSpeed : _currentLap.MaxSpeedKnot;
        
        // moving avg speed 
        //
        _avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedIterator] + _speedKnot;
        _avgSpeedValues[_avgSpeedIterator] = _speedKnot;
        _avgSpeedIterator = (_avgSpeedIterator + 1) % AVG_SPEED_INTERVAL;

        // moving avg bearing
        //
        var sinBearing = Math.sin(positionInfo.heading);
        var cosBearing = Math.cos(positionInfo.heading);
        _sinBearingSum = _sinBearingSum - _avgSinValues[_avgBearingIterator] + sinBearing;
        _avgSinValues[_avgBearingIterator] = sinBearing;
        _cosBearingSum = _cosBearingSum - _avgCosValues[_avgBearingIterator] + cosBearing;
        _avgCosValues[_avgBearingIterator] = cosBearing;
        _avgBearingDegree = (Math.toDegrees(Math.atan2(_sinBearingSum, _cosBearingSum)) + 360).toNumber() % 360;
        _avgBearingIterator = (_avgBearingIterator + 1) % AVG_BEARING_INTERVAL;

        var timelapsSecond = timelaps.toDouble() / 1000;
        _distance += positionInfo.speed * timelapsSecond;
        _duration += timelapsSecond;
        
        _location = positionInfo.position;
	}

	// return all calculated data from GPS 
	//
    function GetGpsInfo()
    {
        var gpsInfo = new GpsInfo();
        gpsInfo.Accuracy = _accuracy;
        gpsInfo.SpeedKnot = _speedKnot;
        gpsInfo.BearingDegree = _bearingDegree;
        gpsInfo.AvgSpeedKnot = _avgSpeedSum / AVG_SPEED_INTERVAL;
        gpsInfo.MaxSpeedKnot = _maxSpeedKnot;
        gpsInfo.IsRecording = _activeSession.isRecording();
        gpsInfo.LapCount = _lapCount;
        gpsInfo.AvgBearingDegree = _avgBearingDegree;
        gpsInfo.TotalDistance = _distance / METERS_PER_NAUTICAL_MILE;
        gpsInfo.GpsLocation = _location; 

        return gpsInfo;
    }

    // Add new lap statistic
    //
    function AddLap()
    {
        // count lap only when recording
        //
        if (!_activeSession.isRecording())
        {
            return false;
        }

        _activeSession.addLap();

        saveLap();

        //LogWrapper.WriteLapStatistic(_currentLap);

        _currentLap = newLap();
       
        return true;       
    }

    // Start & Pause activity recording
    //
    function StartStopRecording()
    {
        if (_accuracy < 2 && !_activeSession.isRecording())
        {
            return false;
        }
        
        if (_activeSession.isRecording())
        {
            _activeSession.stop();
            saveLap();
        }
        else
        {
            _activeSession.start();
            _startTime = (_startTime == null) ? Time.now() : _startTime;
            _currentLap = newLap();
        }
        return true;
    }

    function SaveRecord()
    {
        if (_activeSession != null)
        {
            _activeSession.save();
        }
    }
    
    function DiscardRecord()
    {
        if (_activeSession != null)
        {
            _activeSession.discard();
        }
    }    

	// returns lap data
	//
    function GetLapArray()
    {
    	return _lapArray;
    }
    
    // initialize lap data from external source
    //
    function SetLapArray(lapArray)
    {
    	_lapArray = lapArray;
    	_lapCount = (lapArray.size() > 0)
    		? lapArray[lapArray.size() - 1].LapNumber + 1
    		: 0;
    	_currentLap.LapNumber = _lapCount;
    }

	// return data collected while application was run
	//
    function GetAppStatistic()
    {
        var overall = new LapInfo();
        overall.StartTime = _startTime;
        overall.MaxSpeedKnot = _maxSpeedKnot;
        overall.Distance = _distance / METERS_PER_NAUTICAL_MILE;
        overall.Duration = _duration;
        overall.AvgSpeedKnot =  (_duration > 0) ? overall.Distance / (_duration / Time.Gregorian.SECONDS_PER_HOUR) : 0;
        return overall;
    }

    // save lap statistic to local array
    //
    hidden function saveLap()
    {
        // calculate lap statistics
        //
        _currentLap.Distance = (_distance - _currentLap.Distance) / METERS_PER_NAUTICAL_MILE;
        _currentLap.Duration = (_duration - _currentLap.Duration);
        _currentLap.AvgSpeedKnot = (_currentLap.Duration > 0)
            ? _currentLap.Distance/(_currentLap.Duration.toDouble() / Time.Gregorian.SECONDS_PER_HOUR)
            : 0;

        _lapArray.add(_currentLap);
        
        // no more than 999 laps 
        //
        _lapCount = (_lapCount + 1) % 999;

        // if array oversized - remove oldest element
        //
        if (_lapArray.size() > LAP_ARRAY_MAX)
        {
            _lapArray = _lapArray.slice(1, null);
        }
    }

    // initialize new lap 
    //
    hidden function newLap()
    {
        // Store some current global values to calculate difference later
        //
        var lapInfo = new LapInfo();
        lapInfo.StartTime = Time.now();
        lapInfo.Distance = _distance;        
        lapInfo.Duration = _duration;
        lapInfo.LapNumber = _lapCount;   
        return lapInfo;     
    }
}