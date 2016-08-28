using Toybox.WatchUi as Ui;

class LapViewDelegate extends Ui.BehaviorDelegate 
{
	hidden var _lapView;
	
    function initialize(lapView) 
    {
        BehaviorDelegate.initialize();
        _lapView = lapView;
    }
    
    function onSelect()
    {
    	return true;
    }
}