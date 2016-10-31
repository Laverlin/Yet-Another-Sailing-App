using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

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

    function onShow() 
    {
		Ui.pushView(_cruiseMenuView, _cruiseMenuDelegate, Ui.SLIDE_IMMEDIATE);
    }
}