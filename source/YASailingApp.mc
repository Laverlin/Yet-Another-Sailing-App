using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;
using Toybox.Time as Time;
using Toybox.System as System;

class YASailingApp extends App.AppBase 
{
    hidden var _gpsWrapper;
	hidden var _cruiseView;
	hidden var _raceTimerView;
	hidden var _waypointView;
	hidden var _lapView;
	hidden var _selectRouteView;
	hidden var _isStartSuccess = false;

    function initialize() 
    {
        AppBase.initialize();

		var deviceSettings = System.getDeviceSettings();
		if (deviceSettings.screenShape != 1)
		{
			LogWrapper.WriteWrongDevice();
			System.exit();
		}
		
	    Settings.LoadSettings();        
		_gpsWrapper = new GpsWrapper();
		_selectRouteView = new SelectRouteView(new SelectRouteViewDc());

		if (deviceSettings.screenHeight == 218)
		{
	        _cruiseView = new CruiseView(_gpsWrapper, new CruiseView218Dc());
    	    _raceTimerView = new RaceTimerView(_gpsWrapper, _cruiseView, new RaceTimerView218Dc());
        	_lapView = new LapView(new LapView218Dc(), _gpsWrapper);
        	_waypointView = new WaypointView(_gpsWrapper, new WaypointViewDc());
		}
		else if (deviceSettings.screenHeight == 240)
		{
			_cruiseView = new CruiseView(_gpsWrapper, new CruiseView240Dc());
    	    _raceTimerView = new RaceTimerView(_gpsWrapper, _cruiseView, new RaceTimerView240Dc());
        	_lapView = new LapView(new LapView240Dc(), _gpsWrapper);
        	_waypointView = new WaypointView(_gpsWrapper, new WaypointViewDc());
		}
		else
		{
			LogWrapper.WriteWrongScreen();
			System.exit();
		}
    }

    // onStart() is called on application start up
    //
    function onStart(state) 
    {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
		loadState();
        LogWrapper.WriteAppStart(Time.now());
        _isStartSuccess = true;
    }

    // onStop() is called when your application is exiting
    //
    function onStop(state) 
    {
    	if (!_isStartSuccess)
    	{
    		return;
    	}	
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
		saveState();
        Settings.SaveSettings();

        LogWrapper.WriteAppStatistic(_gpsWrapper.GetAppStatistic(), Time.now());
    }
    
    // Return the initial view of your application here
    //
    function getInitialView() 
    {
        return [ 
        	new StartupView(new Rez.Menus.MainMenu(), 
        	new MainMenuDelegate(_cruiseView, _raceTimerView, _lapView, _waypointView, _selectRouteView, _gpsWrapper)) ];
    }
    
    // handle position event
    //
    function onPosition(info) 
    {
        _gpsWrapper.SetPositionInfo(info);
    }
    
    hidden function loadState()
    {
    	try
    	{
    		var i = 0;
    		var lap = new [6];
    		var lapArray = new[0];
    		do
    		{
    			var lapId = "lapId" + i;
    			lap = getProperty(lapId); 
    			if (lap != null)
    			{
    				lapArray.add(new LapInfo());
    				lapArray[i].LapNumber = lap[0].toNumber();
    				lapArray[i].MaxSpeedKnot = lap[1].toFloat();
    				lapArray[i].AvgSpeedKnot = lap[2].toFloat();
    				lapArray[i].Distance = lap[3].toFloat();
    				lapArray[i].Duration = lap[4].toNumber();
    				lapArray[i].StartTime = new Time.Moment(lap[5].toNumber());
    				i += 1;
    			}
    		}
    		while (lap != null);	
    		_gpsWrapper.SetLapArray(lapArray);
    	}
    	catch(exception)
    	{
    		Sys.println("failed to load state" + exception);
    	}
    }
    
    hidden function saveState()
    {
    	var lapId;
    	
    	var lapArray = _gpsWrapper.GetLapArray();
    	for (var i = 0; i < lapArray.size(); i++)
    	{
    		var lap = new[6];
    		lap[0] = lapArray[i].LapNumber.toString();
    		lap[1] = lapArray[i].MaxSpeedKnot.toString();
    		lap[2] = lapArray[i].AvgSpeedKnot.toString();
    		lap[3] = lapArray[i].Distance.toString();
    		lap[4] = lapArray[i].Duration.toString();
    		lap[5] = lapArray[i].StartTime.value().toString();
    		lapId = "lapId" + i;
    		
    		setProperty(lapId, lap);
    	}
    	
    	// delete unused keys
    	//
    	for (var i = lapArray.size(); i < _gpsWrapper.LAP_ARRAY_MAX; i++)
    	{
    		var lapId = "lapId" + i;
    		deleteProperty(lapId);
    	}
    }
}
