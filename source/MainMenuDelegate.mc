using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// main menu handler
//
class MainMenuDelegate extends Ui.MenuInputDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    hidden var _raceTimerView;
    hidden var _lapView;
    hidden var _waypointView;
    hidden var _selectRouteView;
    
    hidden var _routeCustomMenuView;
    
    function initialize(cruiseView, raceTimerView, lapView, waypointView, selectRouteView, routeCustomMenuView, gpsWrapper) 
    {
        MenuInputDelegate.initialize();
        _cruiseView = cruiseView;
        _raceTimerView = raceTimerView;
        _lapView = lapView;
        _waypointView = waypointView;
        _gpsWrapper = gpsWrapper;
        _selectRouteView = selectRouteView;
        
        _routeCustomMenuView = routeCustomMenuView;
    }

    function onMenuItem(item) 
    {
    	if (item == :raceTimer)
    	{
    		Ui.pushView(_raceTimerView, new RaceTimerViewDelegate(_raceTimerView), Ui.SLIDE_RIGHT);
    	}
        else if (item == :cruiseView)
        {
            Ui.pushView(_cruiseView, new CruiseViewDelegate(_cruiseView, _gpsWrapper), Ui.SLIDE_RIGHT);
        }
        else if (item == :routeMenu)
        {
        	Ui.pushView(
        		_routeCustomMenuView, 
        		new RouteCustomMenuDelegate(_gpsWrapper, _routeCustomMenuView, _waypointView, _selectRouteView), 
        		Ui.SLIDE_RIGHT);
        /*
        	var routeMenu = [];
        	if (Settings.CurrentRoute!= null)
        	{
				routeMenu.add(new DMenuItem (:startRoute, "Start Route", Settings.CurrentRoute["RouteName"], null));
			}
			routeMenu.add(new DMenuItem (:selectRoute, "Select Route", null, null));

			var routeMenuView = new DMenu (routeMenu, "Choose");
			var routeMenuViewDelegate =  new DMenuDelegate (
				routeMenuView, 
				new RouteMenuDelegate(_waypointView, _selectRouteView, _gpsWrapper));
			Ui.pushView(routeMenuView, routeMenuViewDelegate, Ui.SLIDE_IMMEDIATE);
		*/
        	//Ui.pushView(new Rez.Menus.RouteMenu(), new RouteMenuDelegate(_waypointView, _selectRouteView, _gpsWrapper), Ui.SLIDE_RIGHT);
        }
        else if (item == :lapView)
        {
            Ui.pushView(_lapView, new LapViewDelegate(_lapView), Ui.SLIDE_RIGHT);
        }         
        else if (item == :setting)
        {
            Ui.pushView(new Rez.Menus.SettingMenu(), new SettingMenuDelegate(_raceTimerView), Ui.SLIDE_LEFT);
        }
        else if (item == :exitSave) 
        {
            _gpsWrapper.SaveRecord();
            Sys.exit();
        } 
        else if (item == :exitDiscard) 
        {
            _gpsWrapper.DiscardRecord();
            Sys.exit();
        }   
    }
}
