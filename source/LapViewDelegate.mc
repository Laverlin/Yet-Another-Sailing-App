using Toybox.WatchUi as Ui;

class LapViewDelegate extends Ui.BehaviorDelegate 
{
	hidden var _lapView;
	
    function initialize(lapView) 
    {
        BehaviorDelegate.initialize();
		_lapView = lapView;
    }
    
    function onMenu()
    {
    	Ui.popView(Ui.SLIDE_RIGHT);
    }
    
    function onNextPage()
    {
    	_lapView.NextLap();

    	return true;
    }

    function onPreviousPage()
    {
    	_lapView.PreviousLap();
      
        return true;
    }
    
    function onBack()
    {
    	_lapView.DeleteLaps();

    	return true;
    }
    
}
