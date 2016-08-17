<<<<<<< HEAD
using Toybox.WatchUi as Ui;

class IBSailingCruiseDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new IBSailingCruiseMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

=======
using Toybox.WatchUi as Ui;

class IBSailingCruiseDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new IBSailingCruiseMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

>>>>>>> 8287446a037b0986c7ccf7085d0ecada9f0f0873
}