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
            var raceTimerView = new RaceTimerView(_gpsWrapper);
            Ui.pushView(new Rez.Menus.SetTimerMenu(), new SetTimerMenuDelegate(raceTimerView), Ui.SLIDE_LEFT);

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
        else if (item == :lapView)
        {
            var lapArray = _gpsWrapper.GetLapArray();
        	var view = new LapView(lapArray[0]);
        	Ui.switchToView(view, new LapViewDelegate(lapArray), Ui.SLIDE_RIGHT);
        }    
        else if (item == :inverseColor)
        {
        	Settings.InverseColors();
        }  
        else if (item == :isAutoStartRecording)
        {
        	var autoRecordingMenu = new Rez.Menus.AutoRecordingMenu();
        	autoRecordingMenu.setTitle("A. R. (" + (Settings.IsAutoRecording ? "On)" : "Off)"));
        	Ui.pushView(autoRecordingMenu, new AutoRecordingMenuDelegate(), Ui.SLIDE_RIGHT);
        }
    }
}