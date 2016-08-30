using Toybox.WatchUi as Ui;

class LapViewDelegate extends Ui.BehaviorDelegate 
{
	hidden var _lapArray;
    hidden var _lamNum = 0;
	
    function initialize(lapArray) 
    {
        BehaviorDelegate.initialize();
        _lapArray = lapArray;
    }
    
    function onNextPage()
    {
        _lamNum += 1;
        if (_lamNum > 99 || _lapArray[_lamNum] == null)
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
        if (_lamNum < 0 || _lapArray[_lamNum] == null)
        {
            _lamNum += 1;
            return true;
        }

        var view = new LapView(_lapArray[_lamNum]);
        Ui.switchToView(view, self, Ui.SLIDE_UP);        
        return true;
    }
}