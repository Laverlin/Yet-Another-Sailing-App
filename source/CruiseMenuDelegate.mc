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
    		var raceTimerView = new RaceTimerView(_gpsWrapper, _cruiseView);
    		Ui.pushView(raceTimerView, new RaceTimerViewDelegate(raceTimerView), Ui.SLIDE_RIGHT);
    	}
        else if (item == :cruiseView)
        {
            return;
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
    
    function initialize() 
    {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
        if (item == :setTimer)
        {
            Ui.pushView(new Rez.Menus.SetTimerMenu(), new SetTimerMenuDelegate(), Ui.SLIDE_LEFT);
        } 
        else if (item == :backgroundColor)
        {
        	var backgroundMenu = new Rez.Menus.BackgroundColorMenu();
        	backgroundMenu.setTitle("Background (" + (Settings.IsWhiteBackground ? "white)" : "black)"));
        	Ui.pushView(backgroundMenu, new BackgroundMenuDelegate(), Ui.SLIDE_LEFT);
        }  
        else if (item == :isAutoStartRecording)
        {
            var autoRecordingMenu = new Rez.Menus.AutoRecordingMenu();
            autoRecordingMenu.setTitle("Auto Rec. (" + (Settings.IsAutoRecording ? "On)" : "Off)"));
            Ui.pushView(autoRecordingMenu, new AutoRecordingMenuDelegate(), Ui.SLIDE_RIGHT);
        }
    }
}

class BackgroundMenuDelegate extends Ui.MenuInputDelegate 
{
    function initialize() 
    {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
        if (item == :white)
        {
            Settings.SetBackground(true);
        } 
        else if (item == :black)
        {
            Settings.SetBackground(false);
        }  
    }
}