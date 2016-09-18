using Toybox.WatchUi as Ui;

class LapViewDelegate extends Ui.BehaviorDelegate 
{
	hidden var _lapArray;
	hidden var _gpsWrapper;
    hidden var _lamNum = 0;
	
    function initialize(gpsWrapper) 
    {
        BehaviorDelegate.initialize();
        _lapArray = gpsWrapper.GetLapArray();
        _gpsWrapper = gpsWrapper;
    }
    
    function onMenu()
    {
    	Ui.popView(Ui.SLIDE_RIGHT);
    }
    
    function onNextPage()
    {
        _lamNum += 1;
        if (_lamNum >= _lapArray.size())
        {
            _lamNum -= 1;
            return true;
        }

        var view = new LapView(_lapArray[_lamNum]);
        Ui.switchToView(view, self, Ui.SLIDE_DOWN);
    	return true;
    }

    function onPreviousPage()
    {
        _lamNum -= 1;
        if (_lamNum < 0)
        {
            _lamNum += 1;
            return true;
        }

        var view = new LapView(_lapArray[_lamNum]);
        Ui.switchToView(view, self, Ui.SLIDE_UP);        
        return true;
    }
    
    function onBack()
    {
    	if (_lapArray!= null && _lapArray.size() > 0)
    	{
    		Ui.pushView(new Confirmation("Delete Laps?"), new ConfirmDeleteDelegate(_gpsWrapper), Ui.SLIDE_DOWN);
    	}
    	return true;
    }
    
}

class ConfirmDeleteDelegate extends Ui.ConfirmationDelegate
{
	var _gpsWrapper;
	
	function initialize(gpsWrapper)
    {	
        _gpsWrapper = gpsWrapper;
    }
    
    function onResponse(value)
    {
        if( value == CONFIRM_YES )
        {	
    		_gpsWrapper.SetLapArray(new[0]);      	
        }

        var lapArray = _gpsWrapper.GetLapArray();
        var view = new LapView((lapArray.size() == 0) ? null : lapArray[0]);
        Ui.switchToView(view, new LapViewDelegate(_gpsWrapper), Ui.SLIDE_UP); 
    }
}