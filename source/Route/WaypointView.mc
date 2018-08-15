using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;

class WaypointView extends Ui.View 
{
    hidden var _gpsWrapper;
	hidden var _timer;
	hidden var _waypointViewDc;
	hidden var _waypoint;

    function initialize(gpsWrapper, waypointViewDc) 
    {
        View.initialize();
        _gpsWrapper = gpsWrapper;
        _waypointViewDc = waypointViewDc;
    }

	// SetUp timer on show to update every second
    //
    function onShow() 
    {
    	_timer = new Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    	
    	makeRequest();
    }

    // Stop timer then hide
    //
    function onHide() 
    {
        _timer.stop();
    }
    
    // Refresh view every second
    //
    function onTimerUpdate()
    {
        Ui.requestUpdate();
    }    

    // Update the view
    //
    function onUpdate(dc) 
    {   
    	_waypointViewDc.ClearDc(dc);
        
        // Display speed and bearing if GPS available
        //
        var gpsInfo = _gpsWrapper.GetGpsInfo();
        if (gpsInfo.Accuracy > 0)
        {
        	// boat data
        	//
			_waypointViewDc.PrintBearing(dc, gpsInfo.BearingDegree);
			_waypointViewDc.PrintSpeed(dc, gpsInfo.SpeedKnot);
			//_waypointViewDc.PrintBearing(dc, gpsInfo.Bearing);
        }
        
        // Display current state
    	//
        var clockTime = Sys.getClockTime();        
        _waypointViewDc.PrintTime(dc, clockTime);
        _waypointViewDc.DisplayState(dc, gpsInfo.Accuracy, gpsInfo.IsRecording, gpsInfo.LapCount);
        _waypointViewDc.DrawGrid(dc);
    }
    
    
       // set up the response callback function
   function onReceive(responseCode, data) 
   {
       if (responseCode == 200) {
           Sys.println("Request Successful");                   // print success
           Sys.println(data[0]["RouteName"]);
           Sys.println(data[0]["RouteDate"]);
           Sys.println(data[0]["RouteId"]);
       }
       else {
           Sys.println("Response: " + responseCode);            // print response code
       }

   }

   function makeRequest() {
       var url = "http://localhost:3000/garminapi/routelist/-IU43Aiin";     

        var options = {
          :method => Comm.HTTP_REQUEST_METHOD_GET,
          :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

//       var responseCallback = method(:onReceive);                  // set responseCallback to
                                                                   // onReceive() method
       // Make the Communications.makeWebRequest() call
       Comm.makeWebRequest(url, {}, options, method(:onReceive));
  }
}