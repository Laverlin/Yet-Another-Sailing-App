using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class CruiseMenuDelegate extends Ui.MenuInputDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    hidden var _dcWrapper;
    
    function initialize(cruiseView, gpsWrapper, dcWrapper) 
    {
        MenuInputDelegate.initialize();
        _cruiseView = cruiseView;
        _gpsWrapper = gpsWrapper;
        _dcWrapper = dcWrapper;
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
            var lapArray = _gpsWrapper.GetLapArray();
        	var view = new LapView(lapArray[0], _dcWrapper);
        	Ui.switchToView(view, new LapViewDelegate(lapArray, _dcWrapper), Ui.SLIDE_RIGHT);
        	return true;
        }    
        else if (item == :inverseColor)
        {
        	_cruiseView.InverseColor();
        }  
    }
}