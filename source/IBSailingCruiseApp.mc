using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;

class IBSailingCruiseApp extends App.AppBase {

	var cruiseView;
	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) 
    {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    // onStop() is called when your application is exiting
    function onStop(state) 
    {
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    // Return the initial view of your application here
    function getInitialView() 
    {
    	cruiseView = new IBSailingCruiseView();
        return [ cruiseView, new IBSailingCruiseDelegate() ];
    }
    
    function onPosition(info) 
    {
        cruiseView.setPosition(info);
    }
}
