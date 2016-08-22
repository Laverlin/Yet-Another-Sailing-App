using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class IBSailingCruiseMenuDelegate extends Ui.MenuInputDelegate 
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
    }
}