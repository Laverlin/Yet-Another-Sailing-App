using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Lang as Lang;

(:savememory)
class SelectRouteView extends Ui.View 
{
	hidden var _selectRouteViewDc;
	hidden var _loadingError = 0;
	hidden var _routesData = null;
	hidden var _selectedRouteId = 0;
	
    function initialize(selectRouteViewDc) 
    {
        View.initialize();
		_selectRouteViewDc = selectRouteViewDc;
    }

    // Load List of available routes
    //
    function onShow() 
    {
    	if (_routesData == null)
    	{
    		makeLoadRoutesRequest();
    	}
    }
    
    function ClearLoadedRoutes()
    {
    	_routesData = null;
    }
    
    function onUpdate(dc) 
    {   
        _selectRouteViewDc.ClearDc(dc);
        
        if (Settings.UserId.length() < 7 or Settings.UserId.length() > 14)
        {
        	_loadingError = 1;
        }
        
        if (_routesData == null || _routesData.size() == 0)
        {
        	if (_loadingError == 0)
        	{
				_selectRouteViewDc.PrintLoadingMessage(dc);
			}
			else
			{
				_selectRouteViewDc.PrintErrorMessage(dc, _loadingError);
				_loadingError = 0;
			}
		}
		else
		{
			_selectRouteViewDc.PrintSelectedRoute(dc, _routesData[_selectedRouteId], _selectedRouteId, _routesData.size());
		}
	}
	
	
	function NextRoute()
	{
		if (_routesData == null)
		{
			return;
		}
		
		if ( _selectedRouteId < _routesData.size() - 1)
		{
			_selectedRouteId++;
		}
		Ui.requestUpdate();
	}
	
	function PreviousRoute()
	{
		if (_routesData == null)
		{
			return;
		}
			
		if (_selectedRouteId > 0)
		{
			_selectedRouteId--;
		}
		Ui.requestUpdate();
	}
	
	function RouteSelected()
	{
		if (_routesData == null)
		{
			return;
		}
		Settings.CurrentRoute = _routesData[_selectedRouteId];
		Ui.popView(Ui.SLIDE_IMMEDIATE);
	}
	
	// Make web request to load available routes
	//	
	hidden function makeLoadRoutesRequest()
	{
		var url = Lang.format("$1$/route-store/users/$2$/routes?limit=10", [
			Settings.RouteApiUrl,
			Settings.UserId
		]);     
		
        var options = {
          :method => Comm.HTTP_REQUEST_METHOD_GET,
          :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

       Comm.makeWebRequest(url, {}, options, method(:onReceive));
 	}
	
	// Receive routes from server
	//
	function onReceive(responseCode, data)
	{
		if (responseCode != 200)
		{
			_loadingError = responseCode;
			//Sys.println("error loading routes, response code: " + responseCode.toString());
		}
		else if (data.size() == 0)
		{
			_loadingError = -404;
		}
		else
		{
			_routesData = data;
		}
		
		Ui.requestUpdate();
	}
}

