using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class LapView extends Ui.View 
{
    hidden var _lapInfo;

	function initialize(lapInfo) 
    {
        View.initialize();
        
        _lapInfo = lapInfo;
	}

    function onUpdate(dc) 
    {   
    	DcWrapper.PrintLapInfo(dc, _lapInfo);
	}
}