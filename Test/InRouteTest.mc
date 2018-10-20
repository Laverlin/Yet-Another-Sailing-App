using Toybox.Test as Test;

(:debug)
class InRouteTest
{

	(:test)
	function TestXte(logger)
	{
		var nullRoute = {"WayPoints" => {}};
	
		var routeTrack = new RouteTrack(nullRoute);
		
		var xte = routeTrack.GetXte(
			Math.toRadians(18.35585066137293), Math.toRadians(-38.08834475672381), 
			Math.toRadians(18.35585066137293), Math.toRadians(-20.35775407416596),
			Math.toRadians(9.987217572513453), Math.toRadians(-38.04593696104232));
			
		logger.debug("xte: " + xte +" m, " + xte / GpsWrapper.METERS_PER_NAUTICAL_MILE + " nm");
		
		var xte2 = routeTrack.GetXte(Math.toRadians(0), Math.toRadians(-2), Math.toRadians(0), Math.toRadians(2), Math.toRadians(0.016667), Math.toRadians(0));
		logger.debug("xte2: " + xte2 +" m, " + xte2 / GpsWrapper.METERS_PER_NAUTICAL_MILE + " nm");		
		
		var xte22 = routeTrack.GetXte2(Math.toRadians(0), Math.toRadians(-2), Math.toRadians(0), Math.toRadians(2), Math.toRadians(0.016667), Math.toRadians(0));
		logger.debug("xte22: " + xte22 +" m, " + xte22 / GpsWrapper.METERS_PER_NAUTICAL_MILE + " nm");
		
		var xte32 = routeTrack.GetXte3(Math.toRadians(0), Math.toRadians(-2), Math.toRadians(0), Math.toRadians(2), Math.toRadians(0.016667), Math.toRadians(0));
		logger.debug("xte32: " + xte32 +" m, " + xte32 / GpsWrapper.METERS_PER_NAUTICAL_MILE + " nm");
		
		
		return true;
	}
	
	
}