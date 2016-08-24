using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;

class YASailingApp extends App.AppBase 
{
    hidden var _gpsHelper = new GpsHelper();
	hidden var _cruiseView = new CruiseView(_gpsHelper);
    
	
    function initialize() 
    {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    //
    function onStart(state) 
    {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    // onStop() is called when your application is exiting
    //
    function onStop(state) 
    {
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }
    
    // Return the initial view of your application here
    //
    function getInitialView() 
    {
    	var delegate = new CruiseDelegate(_cruiseView);
    	
        return [ _cruiseView, delegate ];
    }
    
    // handle position event
    //
    function onPosition(info) 
    {
        _gpsHelper.SetPositionInfo(info);
    }
}
