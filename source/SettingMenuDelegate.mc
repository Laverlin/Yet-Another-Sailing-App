using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// settin gmenu handler
//
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
        	var backgroundMenu = new Ui.Menu(); 
        	backgroundMenu.setTitle("Background Color");
            backgroundMenu.addItem((Settings.IsWhiteBackground ? "*" : "") + " White", :white);
            backgroundMenu.addItem((Settings.IsWhiteBackground ? "" : "*") + " Black", :black);
        	Ui.pushView(backgroundMenu, new BackgroundColorMenuDelegate(), Ui.SLIDE_LEFT);
        }  
        else if (item == :isAutoStartRecording)
        {
            var autoRecordingMenu = new Ui.Menu();
            autoRecordingMenu.setTitle("Auto Recording");
            autoRecordingMenu.addItem((Settings.IsAutoRecording ? "*" : "") + " On", :isAutoOn);
            autoRecordingMenu.addItem((Settings.IsAutoRecording ? "" : "*") + " Off", :isAutoOff);
            Ui.pushView(autoRecordingMenu, new AutoRecordingMenuDelegate(), Ui.SLIDE_LEFT);
        }
    }
}

class BackgroundColorMenuDelegate extends Ui.MenuInputDelegate 
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

class AutoRecordingMenuDelegate extends Ui.MenuInputDelegate 
{
    function initialize() 
    {
        MenuInputDelegate.initialize();
    }
    
    function onMenuItem(item) 
    {
        if (item == :isAutoOn)
        {
            Settings.SetAutoRecording(true);
        }
        else if (item == :isAutoOff)
        {
            Settings.SetAutoRecording(false);
        }
        
        Ui.popView(Ui.SLIDE_LEFT);
    }
}