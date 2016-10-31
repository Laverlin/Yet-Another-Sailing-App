using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

class LapView extends Ui.View 
{
    hidden var _lapArray;
    hidden var _lapViewDc;
    hidden var _lapNum = 0;
    hidden var _gpsWrapper;

	function initialize(lapViewDc, gpsWrapper) 
    {
        View.initialize();

        _lapViewDc = lapViewDc;
        _gpsWrapper = gpsWrapper;
	}
	
	function SetLapArray(lapArray)
	{
		_lapArray = lapArray;
	}

    function onUpdate(dc) 
    {   
        _lapViewDc.ClearDc(dc);
        
        if (_lapArray == null || _lapArray.size() == 0)
        {
            _lapViewDc.PrintLapsEmpty(dc);
            return;
        }
        
        var lapInfo = _lapArray[_lapNum];
		_lapViewDc.PrintLapInfo(dc, lapInfo);
	}
	
	function NextLap()
	{
		_lapNum += 1;
        if (_lapNum >= _lapArray.size())
        {
            _lapNum -= 1;
        }
        Ui.requestUpdate();
	}
	
	function PreviousLap()
	{
		_lapNum -= 1;
        if (_lapNum < 0)
        {
            _lapNum += 1;
        }
        Ui.requestUpdate();
	}
	
	function DeleteLaps()
	{
		if (_lapArray!= null && _lapArray.size() > 0)
    	{
    		Ui.pushView(new Confirmation("Delete Laps?"), new ConfirmDeleteDelegate(_gpsWrapper), Ui.SLIDE_DOWN);
    	}
	}
}

class ConfirmDeleteDelegate extends Ui.ConfirmationDelegate
{
	var _gpsWrapper;
	
	function initialize(gpsWrapper)
    {	
        ConfirmationDelegate.initialize();
        _gpsWrapper = gpsWrapper;
    }
    
    function onResponse(value)
    {
        if( value == CONFIRM_YES )
        {	
    		_gpsWrapper.SetLapArray(new[0]);      	
        }
    }
}