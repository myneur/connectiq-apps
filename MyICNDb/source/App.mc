using Toybox.Application as App;
using Toybox.System as Sys;

class App extends App.AppBase {
    function onStart() {
        clearProperties();
    }

    function onStop() {
    }

    function getInitialView() {
        var view = new TopView();
        return BDIT.Splash.splashIfNeeded(view, view.getBehavior());
    }
}