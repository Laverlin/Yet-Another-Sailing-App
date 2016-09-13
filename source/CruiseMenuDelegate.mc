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
        else if (item == :cruiseView)
        {
            Ui.popView(Ui.SLIDE_RIGHT);
        }
        else if (item == :lapView)
        {
            var lapArray = _gpsWrapper.GetLapArray();
            var view = new LapView(lapArray[0]);
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


class SettingMenuDelegate extends Ui.MenuInputDelegate 
{
    hidden var _gpsWrapper;
    
    function initialize(gpsWrapper) 
    {
        MenuInputDelegate.initialize();
        _cruiseView = cruiseView;
        _gpsWrapper = gpsWrapper;
    }

    function onMenuItem(item) 
    {
        if (item == :setTimer)
        {
            Ui.pushView(new Rez.Menus.SetTimerMenu(), new SetTimerMenuDelegate(), Ui.SLIDE_LEFT);
        } 
        else if (item == :inverseColor)
        {
            Settings.InverseColors();
        }  
        else if (item == :isAutoStartRecording)
        {
            var autoRecordingMenu = new Rez.Menus.AutoRecordingMenu();
            autoRecordingMenu.setTitle("Auto Rec. (" + (Settings.IsAutoRecording ? "On)" : "Off)"));
            Ui.pushView(autoRecordingMenu, new AutoRecordingMenuDelegate(), Ui.SLIDE_RIGHT);
        }
    }
}