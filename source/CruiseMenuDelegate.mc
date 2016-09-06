using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class CruiseMenuDelegate extends Ui.MenuInputDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    
    function initialize(cruiseView, gpsWrapper) 
    {
        MenuInputDelegate.initialize();
        _cruiseView = cruiseView;
        _gpsWrapper = gpsWrapper;
    }

    function onMenuItem(item) 
    {
    	if (item == :raceTimer)
    	{
    		var raceTimerView = new RaceTimerView(_gpsWrapper);
    		Ui.switchToView(raceTimerView, new RaceTimerViewDelegate(raceTimerView), Ui.SLIDE_RIGHT);
    	}
    	
        else if (item == :setTimer)
        {
            Ui.pushView(new Rez.Menus.SetTimerMenu(), new SetTimerMenuDelegate(), Ui.SLIDE_LEFT);

        } 
        else if (item == :exitSave) 
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
        	var view = new LapView(lapArray[0]);
        	Ui.switchToView(view, new LapViewDelegate(lapArray), Ui.SLIDE_RIGHT);
        	return true;
        }    
        else if (item == :inverseColor)
        {
        	Settings.InverseColors();
            return true;
        }  

    }
}