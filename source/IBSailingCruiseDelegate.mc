
using Toybox.WatchUi as Ui;

class IBSailingCruiseDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new IBSailingCruiseMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
}