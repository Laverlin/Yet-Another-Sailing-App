using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// main menu handler
//
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
    		var raceTimerView = new RaceTimerView(_gpsWrapper, _cruiseView);
    		Ui.pushView(raceTimerView, new RaceTimerViewDelegate(raceTimerView), Ui.SLIDE_RIGHT);
    	}
        else if (item == :cruiseView)
        {
            // Cruise is a main view, so if pop out here - application terminated, hence just return
            //
            return;
        }
        else if (item == :lapView)
        {
            var lapArray = _gpsWrapper.GetLapArray();
            var view = new LapView((lapArray.size() == 0) ? null : lapArray[0]);
            Ui.pushView(view, new LapViewDelegate(lapArray), Ui.SLIDE_RIGHT);
        }         
        else if (item == :setting)
        {
            Ui.pushView(new Rez.Menus.SettingMenu(), new SettingMenuDelegate(), Ui.SLIDE_LEFT);
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
