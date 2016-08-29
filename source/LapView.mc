using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class LapView extends Ui.View 
{
    hidden var _lapInfo;
    hidden var _dcWrapper;

	function initialize(lapInfo, dcWrapper) 
    {
        View.initialize();
        
        _lapInfo = lapInfo;
        _dcWrapper = dcWrapper;
	}

    function onUpdate(dc) 
    {   
    	_dcWrapper.PrintLapInfo(dc, _lapInfo);
	}
}