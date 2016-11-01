using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// Stub view, just switch to MainMenu. 
// This is workaround to start app from menu view, because getItitialView does not support Menu
//
class StartupView extends Ui.View 
{
	hidden var _cruiseMenuView;
	hidden var _cruiseMenuDelegate;
	
    function initialize(cruiseMenuView, cruiseMenuDelegate) 
    {
        View.initialize();
        
        _cruiseMenuView = cruiseMenuView;
		_cruiseMenuDelegate = cruiseMenuDelegate;
    }

    // just switch to main menu as soon as shows
    //
    function onShow() 
    {
		Ui.pushView(_cruiseMenuView, _cruiseMenuDelegate, Ui.SLIDE_IMMEDIATE);
    }
}