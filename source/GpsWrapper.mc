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
        _activeSession = Fit.createSession({:name => "Sailing", :sport => Fit.SPORT_GENERIC});
    }

	function SetPositionInfo(positionInfo)
	{
        _accuracy = (positionInfo != null) ? positionInfo.accuracy : 0;
        if (_accuracy < 1 )
        {
            return;
        }

        // perform autostart recording 
        //
        if (Settings.IsAutoRecording && !_isAutoRecordStart)
        {
        	_isAutoRecordStart = true;
        	StartStopRecording();
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

        _currentLap.MaxSpeedKnot = (_currentLap.MaxSpeedKnot < _speedKnot) ? _speedKnot : _currentLap.MaxSpeedKnot;

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
        gpsInfo.IsRecording = _activeSession.isRecording();
        gpsInfo.LapCount = _lapCount;

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

        LogWrapper.WriteLapStatistic(_currentLap);

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

    function GetLapArray()
    {
    	return _lapArray;
    }

    function GetAppStatistic()
    {
        var overall = new LapInfo();
        overall.StartTime = _startTime;
        overall.MaxSpeedKnot = _maxSpeedKnot;
        overall.Distance = _distance / 1852;
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
        _currentLap.Distance = (_distance - _currentLap.Distance) / 1852;
        _currentLap.Duration = (_duration - _currentLap.Duration);
        _currentLap.AvgSpeedKnot = (_currentLap.Duration > 0)
            ? _currentLap.Distance/(_currentLap.Duration.toDouble() / Time.Gregorian.SECONDS_PER_HOUR)
            : 0;

        _lapArray[_lapCount] = _currentLap;
        _lapCount = _lapCount + 1;
    }

    // initialize new lap 
    //
    hidden function newLap()
    {
        // Store some current global values to calculate difference later
        //
        var lap = new LapInfo();
        lap.StartTime = Time.now();
        lap.Distance = _distance;        
        lap.Duration = _duration;
        lap.LapNumber = _lapCount;   
        return lap;     
    }
}