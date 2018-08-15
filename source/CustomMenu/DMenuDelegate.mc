using Toybox.WatchUi as Ui;


class DMenuDelegate extends Ui.BehaviorDelegate 
{
	hidden var menu;
	hidden var userMenuDelegate;
	
	function initialize (_menu, _userMenuInputDelegate)
	{
		menu = _menu;
		userMenuDelegate = _userMenuInputDelegate;
		BehaviorDelegate.initialize ();
	}
	
	function onNextPage ()
	{
		menu.updateIndex (1);
		return true;
	}
	
	function onPreviousPage ()
	{
		menu.updateIndex (-1);
		return true;		
	}
	
	function onSelect ()
	{
		userMenuDelegate.onMenuItem (menu.selectedItem ());
		Ui.requestUpdate();
		return true;
	}
	
    function onBack () 
	{
        Ui.popView (Ui.SLIDE_RIGHT);
		return true;
    }
}
