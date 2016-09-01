using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;
using Toybox.Time as Time;

class YASailingApp extends App.AppBase 
{
    hidden var _gpsWrapper;
	hidden var _cruiseView;

    function initialize() 
    {
        AppBase.initialize();

        Settings.LoadSettings();        

        _gpsWrapper = new GpsWrapper();
        _cruiseView = new CruiseView(_gpsWrapper);
    }

    // onStart() is called on application start up
    //
    function onStart(state) 
    {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        LogWrapper.WriteAppStart(Time.now());
    }

    // onStop() is called when your application is exiting
    //
    function onStop(state) 
    {
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        Settings.SaveSettings();
        _gpsWrapper.Cleanup();
        LogWrapper.WriteAppStatistic(_gpsWrapper.GetAppStatistic(), Time.now());
        
    }
    
    // Return the initial view of your application here
    //
    function getInitialView() 
    {
    	var delegate = new CruiseDelegate(_cruiseView, _gpsWrapper);
    	
        return [ _cruiseView, delegate ];
    }
    
    // handle position event
    //
    function onPosition(info) 
    {
        _gpsWrapper.SetPositionInfo(info);
    }
}
