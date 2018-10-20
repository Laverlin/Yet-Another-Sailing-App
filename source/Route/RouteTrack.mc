using Toybox.System as Sys;
using Toybox.Math as Math;
using Toybox.Test as Test;

// calculate current in route position
//
(:savememory)
class RouteTrack
{
	hidden var _currentWayPoint = 0;
	hidden var _totalWayPoints;
	hidden var _currentRoute;

	hidden var _routeDistance = 0.0;
	hidden var _isRouteFinished = false;
	hidden var _currentLegBearing; // bearing between two wps on current leg
	
	hidden var _wpEpsilon;

	const EARTH_RADIUS_M = 6378137;
	
	// Return route distance from current Waypoint to Finish
	//
	hidden function getRouteDistance()
	{
		var routeDistance = 0;
		for(var i = _currentWayPoint; i < _currentRoute["WayPoints"].size() - 1; i++)
    	{
    		routeDistance = routeDistance + GetDistance(	
    			Math.toRadians(_currentRoute["WayPoints"][i]["Lat"].toFloat()), 
    			Math.toRadians(_currentRoute["WayPoints"][i]["Lon"].toFloat()),
    			Math.toRadians(_currentRoute["WayPoints"][i+1]["Lat"].toFloat()), 
    			Math.toRadians(_currentRoute["WayPoints"][i+1]["Lon"].toFloat()));
    	}
    	
    	return routeDistance;
	}
	
	// Return bearing between two WP of current leg
	// 
	hidden function getCurrentLegBearing()
	{
		if (_currentWayPoint > 0)
		{
			return GetBearing(
				Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint - 1]["Lat"].toFloat()), 
				Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint - 1]["Lon"].toFloat()), 
				Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint]["Lat"].toFloat()), 
				Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint]["Lon"].toFloat()));
		}
		
		return null;
	}
	
	// Increase or decrease current waypoint
	//
	hidden function changeCurrentWp(newWp)
	{
		if (newWp > _totalWayPoints - 1)
		{
			_isRouteFinished = true;
			SignalWrapper.Start();
			return;
		}
		
		if (newWp < 0)
		{
			return;
		}

		_isRouteFinished = false;
		_currentWayPoint = newWp;
		_currentLegBearing = getCurrentLegBearing();		
		_routeDistance = getRouteDistance();
		_currentRoute.put("CurrentWayPoint", _currentWayPoint);
		SignalWrapper.PressButton();
	}
	
	function initialize(currentRoute)
	{
		Test.assertMessage(currentRoute != null, "currentRoute can not be null!");
		Test.assertMessage(currentRoute["WayPoints"] != null, "currentRoute should have WayPoints dictionary.");
		
		_currentRoute = currentRoute;
		_totalWayPoints = _currentRoute["WayPoints"].size();
		if (_currentRoute["CurrentWayPoint"] != null)
		{
			_currentWayPoint = _currentRoute["CurrentWayPoint"];
		}
		_currentLegBearing = getCurrentLegBearing();
		_wpEpsilon = Settings.WpEpsilon;
		_routeDistance = getRouteDistance();
	}
	
	// Return total Waypoints in actual route
	//
	function TotalWayPoints()
    {
    	return _totalWayPoints;
    }
    
    // Return current waypoint in actual route
    //
    function GetCurrentWayPoint()
    {
    	return _currentWayPoint + 1;
    }
	
	// return current in route data
	//
	function GetInRouteInfo(gpsInfo)
	{
	    var wpLat = Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint]["Lat"].toFloat());
    	var wpLon = Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint]["Lon"].toFloat());
    	var gpsLocation = gpsInfo.GpsLocation.toRadians();
    	var gpsLat = gpsLocation[0];
    	var gpsLon = gpsLocation[1];
	
		var distance2Wp = GetDistance(gpsLat, gpsLon, wpLat, wpLon);
		var inRouteInfo = new InRouteInfo();
		inRouteInfo.Distance2Wp = distance2Wp / GpsWrapper.METERS_PER_NAUTICAL_MILE;
		inRouteInfo.Bearing = GetBearing(gpsLat, gpsLon, wpLat, wpLon);
		inRouteInfo.Vmg = GetVmg(gpsInfo.SpeedKnot, gpsInfo.BearingDegree, inRouteInfo.Bearing);
		inRouteInfo.Distance2Finish = (_routeDistance + distance2Wp) / GpsWrapper.METERS_PER_NAUTICAL_MILE;

		if (_currentWayPoint > 0)
		{
			inRouteInfo.Xte = GetXte(distance2Wp, inRouteInfo.Bearing) / GpsWrapper.METERS_PER_NAUTICAL_MILE;
		}
		else
		{
			inRouteInfo.Xte = 0;
		}
		
		if (distance2Wp < _wpEpsilon)
		{
			changeCurrentWp(_currentWayPoint + 1);
		}
		
		return inRouteInfo;
	}
	
	function NextWayPoint()
	{
		changeCurrentWp(_currentWayPoint + 1);
	}
	
	function PrevWayPoint()
	{
		changeCurrentWp(_currentWayPoint - 1);
	}
	
	function GetIsRouteFinished()
	{
		return _isRouteFinished;
	}
	
	// return distance between two GPS points. 
	// lat & lon suppose to be in radians
	//
	function GetDistance(latStart, lonStart, latEnd, lonEnd)
	{
    	var LatDiff = latEnd - latStart;
  		var LonDiff = lonEnd - lonStart;

		var a = Math.pow(Math.sin(LatDiff/2), 2) +
  		Math.pow(Math.sin(LonDiff/2), 2) * Math.cos(latStart) * Math.cos(latEnd);
 		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  		var distance = EARTH_RADIUS_M * c;
  		return distance;
	}
	
	// return bearing between two GPS points
	// lat & lon suppose to be in radians
	//
	function GetBearing(latStart, lonStart, latEnd, lonEnd)
    {
  		var LonDiff = lonEnd - lonStart;
  		
        var y = Math.sin(LonDiff) * Math.cos(latEnd);
        var x = Math.cos(latStart) * Math.sin(latEnd) - Math.sin(latStart) * Math.cos(latEnd) * Math.cos(LonDiff);
        var r = Math.toDegrees(Math.atan2(y, x));
        var bearing = (r + 360).toNumber() % 360;
        return bearing;
    }
	
	// Return Cross-Track Error in meters
	//    
    function GetXte(distance2Wp, bearing2Wp)
    {
    	return distance2Wp * Math.sin(Math.toRadians(_currentLegBearing - bearing2Wp));
    }
    
    // Return VMG to nearest Way Point
    //
    function GetVmg(speed, bearing, cts)
    {
    	return speed * Math.cos(Math.toRadians(cts - bearing));
    }
}