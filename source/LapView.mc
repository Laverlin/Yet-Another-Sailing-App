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
    	var lapInfo = _lapArray[_lamNum];
        _lapViewDc.ClearDc(dc);
        
        if (_lapArray == null || lapInfo == null)
        {
            _lapViewDc.PrintLapsEmpty(dc);
            return;
        }
        
		_lapViewDc.PrintLapInfo(dc, lapInfo);
	}
	
	function NextLap()
	{
		_lamNum += 1;
        if (_lamNum >= _lapArray.size())
        {
            _lamNum -= 1;
        }
        Ui.requestUpdate();
	}
	
	function PreviousLap()
	{
		_lamNum -= 1;
        if (_lamNum < 0)
        {
            _lamNum += 1;
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
        _gpsWrapper = gpsWrapper;
        ConfirmationDelegate.initialize();
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