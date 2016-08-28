using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class CruiseMenuDelegate extends Ui.MenuInputDelegate 
{
    var _cruiseView;
    
    function initialize(cruiseView) 
    {
        MenuInputDelegate.initialize();
        _cruiseView = cruiseView;
    }

    function onMenuItem(item) 
    {
        if (item == :exitSave) 
        {
            _cruiseView.SaveActivity();
            Sys.exit();
        } 
        else if (item == :exitDiscard) 
        {
            _cruiseView.DiscardActivity();
            Sys.exit();
        }   
        else if (item == :lapView)
        {
        	var view = new LapView(_cruiseView.GpsWrapper());
        	Ui.switchToView(view, new LapViewDelegate(view), Ui.SLIDE_RIGHT);
        	return true;
        }    
        else if (item == :inverseColor)
        {
        	_cruiseView.InverseColor();
        }  
    }
}