using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Lang as Lang;

class SelectRouteView extends Ui.View 
{
	hidden var _selectRouteViewDc;
	hidden var _loadingError = 0;
	
	var IsSelectionMade = false;
	
    function initialize(selectRouteViewDc) 
    {
        View.initialize();
		_selectRouteViewDc = selectRouteViewDc;
    }

    // Load List of available routes
    //
    function onShow() 
    {
    	if (IsSelectionMade)
    	{
    		IsSelectionMade = false;
    		Ui.popView(Ui.SLIDE_IMMEDIATE);
    		return;
    	}
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
			_loadingError = 0;
		}
	}
	
	function makeLoadRoutesRequest()
	{
		var url = Lang.format("$1$/$2$/$3$", [
			Settings.RouteApiUrl,
			Settings.RouteListMethod,
			Settings.UserId]);     

		Sys.println(url);
		
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
			Sys.println(data);
			Ui.requestUpdate();
			return;
		}
		
		var selectRouteMenu = [];
	
		for( var i = 0; i < data.size(); i++ )
		{
			var routeDate = data[i]["RouteDate"].substring(0, 10) + " " + data[i]["RouteDate"].substring(11, 16); 
			selectRouteMenu.add(new DMenuItem (data[i]["RouteId"], data[i]["RouteName"], routeDate, data[i]));
		}

		var routeListView = new DMenu (selectRouteMenu, "Select Route");
		var routeListViewDelegate =  new DMenuDelegate (routeListView, new SelectRouteDelegate(self));
		Ui.pushView(routeListView, routeListViewDelegate, Ui.SLIDE_IMMEDIATE);
	}
}

// Select route menu processing
//
class SelectRouteDelegate extends Ui.MenuInputDelegate 
{
	var _selectRouteView;
	
    function initialize (selectRouteView)
	{
        MenuInputDelegate.initialize ();
        _selectRouteView = selectRouteView;
    }

    function onMenuItem (item) 
	{
		Settings.CurrentRoute = item.userData;
		
		Sys.println(Settings.CurrentRoute["RouteName"]);
		
		Ui.popView(Ui.SLIDE_IMMEDIATE);
		_selectRouteView.IsSelectionMade = true;
    }
}