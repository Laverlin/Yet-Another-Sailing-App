using Toybox.Lang as Lang;

// Route Data
//
class RouteInfo 
{
	function initialize(routeId, routeName, routeDate, wayPoints)
	{
		RouteId = routeId;
		RouteName = routeName;
		RouteDate = routeDate;
		WayPoints = wayPoints;
	}
	
	var RouteName;
	var RouteDate;
	var RouteId;
	var WayPoints;
}