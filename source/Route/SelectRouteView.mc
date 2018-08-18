using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;

class SelectRouteView extends Ui.View 
{
	hidden var _selectRouteViewDc;
	hidden var _loadingError = 0;
	
    function initialize(selectRouteViewDc) 
    {
        View.initialize();
		_selectRouteViewDc = selectRouteViewDc;
    }

    // Load List of available routes
    //
    function onShow() 
    {
    	makeLoadRoutesRequest();
    }
    
    function onUpdate(dc) 
    {   
        _selectRouteViewDc.ClearDc(dc);
        
        if (_loadingError == 0)
        {
			_selectRouteViewDc.PrintLoadingMessage(dc, "Routes loading...");
		}
		else
		{
			_selectRouteViewDc.PrintErrorMessage(dc, "Loading Error", "Code: " + _loadingError.toString());
		}
	}
	
	function makeLoadRoutesRequest()
	{
		var url = "http://localhost:3000/garminapi/routelist/-IU43Aiin";     

        var options = {
          :method => Comm.HTTP_REQUEST_METHOD_GET,
          :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

       Comm.makeWebRequest(url, {}, options, method(:onReceive));
	}
	
	function onReceive(responseCode, data)
	{
		if (responseCode != 200)
		{
			_loadingError = responseCode;
			Sys.println("error loading routes, response code: " + responseCode.toString());
			Ui.requestUpdate();
			return;
		}
		
		var selectRouteMenu = [];
	
		for( var i = 0; i < data.size(); i++ )
		{
			selectRouteMenu.add(new DMenuItem (data[i]["RouteId"], data[i]["RouteName"], data[i]["RouteDate"], data[i]["WayPoints"]));
		}

		var routeListView = new DMenu (selectRouteMenu, "Select Route");
		var routeListViewDelegate =  new DMenuDelegate (routeListView, new SelectRouteDelegate());
		Ui.pushView(routeListView, routeListViewDelegate, Ui.SLIDE_IMMEDIATE);
	}
}

// Select route menu processing
//
class SelectRouteDelegate extends Ui.MenuInputDelegate 
{

	
    function initialize ()
	{
        MenuInputDelegate.initialize ();
    }

    function onMenuItem (item) 
	{
		Sys.println(item.id);
		Sys.println(item.label);
		Sys.println(item.value);
    }
    
    
}