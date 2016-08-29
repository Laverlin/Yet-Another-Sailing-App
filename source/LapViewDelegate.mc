using Toybox.WatchUi as Ui;

class LapViewDelegate extends Ui.BehaviorDelegate 
{
	hidden var _lapAppay;
	
    function initialize(lapArray) 
    {
        BehaviorDelegate.initialize();
        _lapArray = lapArray;
    }
    
    function onSelect()
    {
    	return true;
    }
}