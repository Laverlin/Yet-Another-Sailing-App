using Toybox.System as Sys;
using Toybox.Math as Math;

// calculate current in route position
//
class RouteTrack
{
	hidden var _currentWayPoint = 0;
	hidden var _totalWayPoints;
	hidden var _currentRoute;

	hidden var _routeDistance = 0.0;
	hidden var _isRouteFinished = false;
	
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
	
	// Increase or decrease current waypoint
	//
	hidden function changeCurrentWp(newWp)
	{
		if (newWp > _totalWayPoints - 1)
		{
			_isRouteFinished = true;
			return;
		}
		
		if (newWp < 0)
		{
			return;
		}
		
		_isRouteFinished = false;
		_currentWayPoint = newWp;
		_routeDistance = getRouteDistance();
		_currentRoute.put("CurrentWayPoint", _currentWayPoint);
		SignalWrapper.PressButton();
	}
	
	function initialize(currentRoute)
	{
		_currentRoute = currentRoute;
		_totalWayPoints = _currentRoute["WayPoints"].size();
		if (_currentRoute["CurrentWayPoint"] != null)
		{
			_currentWayPoint = _currentRoute["CurrentWayPoint"];
		}
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
			inRouteInfo.Xte = getXte(
				Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint - 1]["Lat"].toFloat()),
				Math.toRadians(_currentRoute["WayPoints"][_currentWayPoint - 1]["Lon"].toFloat()),
				wpLat, wpLon,
				gpsLat, gpsLon) / GpsWrapper.METERS_PER_NAUTICAL_MILE;
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
	
	// return cross-track error - distance between start-end line and the point
	//
	function GetXte(startLat, startLon, endLat, endLon, pointLat, pointLon)
    {
       	var d13 = GetDistance(startLat, startLon, pointLat, pointLon) / EARTH_RADIUS_M;
    	var bearing13 = GetBearing(startLat, startLon, pointLat, pointLon);
    	var bearing12 = GetBearing(startLat, startLon, endLat, endLon);
      	
    	return Math.asin(Math.sin(d13) * Math.sin(Math.toRadians(bearing13-bearing12))) * EARTH_RADIUS_M; 
    }
    
    function GetXte2(startLat, startLon, endLat, endLon, pointLat, pointLon)
    {
       	var d13 = GetDistance(pointLat, pointLon, endLat, endLon ) / EARTH_RADIUS_M;
    	var bearing13 = GetBearing(pointLat, pointLon, endLat, endLon);
    	var bearing12 = GetBearing(startLat, startLon, endLat, endLon);
      	
    	return Math.asin(Math.sin(d13) * Math.sin(Math.toRadians(bearing13-bearing12))) * EARTH_RADIUS_M; 
    }
    
    function GetVmg(speed, bearing, cts)
    {
    	return speed * Math.cos(Math.toRadians(cts - bearing));
    }

}
