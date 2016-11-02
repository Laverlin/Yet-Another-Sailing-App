using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// Stub view, just switch to MainMenu. 
// This is workaround to start app from menu view, because getItitialView does not support Menu
//
class StartupView extends Ui.View 
{
	hidden var _mainMenuView;
	hidden var _mainMenuDelegate;
	
    function initialize(mainMenuView, mainMenuDelegate) 
    {
        View.initialize();
        
        _mainMenuView = mainMenuView;
		_mainMenuDelegate = mainMenuDelegate;
    }

    // just switch to main menu as soon as shows
    //
    function onShow() 
    {
		Ui.pushView(_mainMenuView, _mainMenuDelegate, Ui.SLIDE_IMMEDIATE);
    }
}