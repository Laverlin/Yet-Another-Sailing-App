using Toybox.System as Sys;
using Toybox.Math as Math;

// calculate current in route position
//
class RouteTrack
{
	hidden var _currentWayPoint = 0;
	hidden var _totalWayPoints;
	hidden var _currentRoute;
	
	hidden var _lastKnownDistance = 0;
	hidden var _currentDistance = 0;
	hidden var _lastKnownTime = 0;
	hidden var _currentTime = 0; 
	hidden var _distanceWp2Finish = 0.0;
	hidden var _isRouteFinished = false;
	
	hidden var _wpEpsilon;

	hidden var _gvmg = 0;

	const EARTH_RADIUS_M = 6378137;
	
	hidden function getVmg(currentDistance2Wp)
	{
		var vmg = 0;
		if (_lastKnownTime == 0)
		{
			_lastKnownTime = Sys.getTimer();
			_lastKnownDistance = currentDistance2Wp;
		}
		else
		{
			_currentDistance = currentDistance2Wp;
			_currentTime = Sys.getTimer();
			var timeLaps = (_currentTime - _lastKnownTime).toDouble() / 1000;
//			if (_lastKnownDistance - _currentDistance == 0)
//			{
//				return _gvmg;
//			}
			vmg = (_lastKnownDistance - _currentDistance) / timeLaps;
			_gvmg = vmg;
			_lastKnownDistance = _currentDistance;
			_lastKnownTime = _currentTime;
			
//			Sys.println("timelaps: " + timeLaps + ", distance: " + _currentDistance );
		}

		return vmg;
	}
	
	hidden function getDistance2Finish(distance2Wp)
	{
		if (_distanceWp2Finish == 0)
		{
		  	for(var i = _currentWayPoint; i < _currentRoute["WayPoints"].size() - 1; i++)
    		{
    			_distanceWp2Finish = _distanceWp2Finish + GetDistance(	
    				Math.toRadians(_currentRoute["WayPoints"][i]["Lat"].toFloat()), 
    				Math.toRadians(_currentRoute["WayPoints"][i]["Lon"].toFloat()),
    				Math.toRadians(_currentRoute["WayPoints"][i+1]["Lat"].toFloat()), 
    				Math.toRadians(_currentRoute["WayPoints"][i+1]["Lon"].toFloat()));
    		}
    	}
    	
    	return _distanceWp2Finish + distance2Wp;
	}
	
	hidden function changeCurrentWp()
	{
		_currentWayPoint++;
		if (_currentWayPoint > _totalWayPoints - 1)
		{
			_currentWayPoint--;
			_isRouteFinished = true;
			return;
		}
		
		_distanceWp2Finish = 0; // to recalculate without passed WP
		_currentRoute.put("CurrentWayPoint", _currentWayPoint);
		_gpsWrapper.AddLap();
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
	}
	
	// Return total Waypoints in actual route
	//
	function TotalWayPoints()
    {
    	return _totalWayPoints;
    }
    
    // Return current waypoint in actual route
    //
    function CurrentWayPoint()
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
		//inRouteInfo.Vmg = getVmg(distance2Wp) * GpsWrapper.MS_TO_KNOT;
		inRouteInfo.Vmg = GetVmg2(gpsInfo.SpeedKnot, gpsInfo.BearingDegree, inRouteInfo.Bearing);
		inRouteInfo.Distance2Finish = getDistance2Finish(distance2Wp) / GpsWrapper.METERS_PER_NAUTICAL_MILE;
		inRouteInfo.IsRouteFinished = _isRouteFinished;
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
			changeCurrentWp();
		}
		
		return inRouteInfo;
	}
	
	function SkipWayPoint()
	{
		changeCurrentWp();
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
	function getXte(startLat, startLon, endLat, endLon, pointLat, pointLon)
    {
       	var d13 = GetDistance(startLat, startLon, pointLat, pointLon) / EARTH_RADIUS_M;
    	var bearing13 = GetBearing(startLat, startLon, pointLat, pointLon);
    	var bearing12 = GetBearing(startLat, startLon, endLat, endLon);
      	
    	return Math.asin(Math.sin(d13) * Math.sin(Math.toRadians(bearing13-bearing12))) * EARTH_RADIUS_M; 
    }
    
    function GetVmg2(speed, bearing, cts)
    {
    	return speed * Math.cos(Math.toRadians(cts-bearing));
    }

}
