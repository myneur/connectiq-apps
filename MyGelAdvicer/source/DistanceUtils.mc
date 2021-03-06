module BDIT {
module DistanceUtils {
    const VERSION = "2015-02-18";

    using Toybox.System as Sys;
    using Toybox.Math;

    const NO_DATA = [null, null];

    //! The radius of earth in m
    const RADIUS_EARTH = 6371000;

    //! 2 pi R/2 pi

    //! Calculates and return the distance and heading between two Location object.
    //! Handles the case, where any of the objects are null or designates no location in 920xt or the simulartor.
    //! Returns [null, null] in this case.
    //!
    //! @param [Toybox.Position.Location] start the start location
    //! @param [Toybox.Position.Location] end the end location
    //! @returns [[Float, Float]] the distance (in meters) and the heading (in radians) from start to end
    function calcDistHeading(start, end) {
        if (start == null || end == null) {
            return NO_DATA;
        }
        // @type [lat, long]
        // Unfortunately I have to convert the results of toRadians to save memory :-(
        var startLL = start.toRadians();
        var startLat = startLL[0].toFloat();
        var startLong = startLL[1].toFloat();
        startLL = null;

        //Sys.println("s="+startLat.toString()+" "+MCUtils.typeof(startLat));
        //Sys.println("pi="+Math.PI.toString()+" "+MCUtils.typeof(Math.PI));
        if (startLat == Math.PI && startLong == Math.PI) {
            return NO_DATA;
        }

        // @type [lat, long]
        var endLL = end.toRadians();
        var endLat = endLL[0].toFloat();
        var endLong = endLL[1].toFloat();
        endLL = null;

        // Vector from end to start
        var dlat = startLat-endLat;
        var dlong = startLong-endLong;

        var dist = Math.sqrt(Math.pow(dlat, 2)+Math.pow(dlong, 2))*RADIUS_EARTH;

        // 0 is north, PI/2 is due east, etc
        var heading = 0;
        // This seems to be necessary to avoid a problem with atan for small values
        if (dlat.abs() < 1e-8 || (dlong/dlat).abs() < 1e-4) {
            if (dlong >= 0) {
                heading = Math.PI/2;
            } else {
                heading = -Math.PI/2;
            }
        } else {
            var d = dlong/dlat;
            heading = Math.atan(d);
            if (dlat < 0) {
                heading += Math.PI;
            }
            if (heading < 0) {
                heading += 2.0*Math.PI;
            }
        }
        heading = heading*360.0/(2.0*Math.PI);

        //Sys.println("* "+startLat.toString()+" "+startLong.toString()+"  -->  "+endLat.toString()+" "+endLong.toString()+" = "+dlat.toString()+" "+dlong.toString());

        return [dist, heading];
    }

    //! Converts the specified distance to a string
    //! @param dist [Float]: the distance to convert (in meters)
    //! @returns [String]: the converted distance
    function distToString(dist) {
        // Format the distance
        var unit = "m";
        var du = Sys.getDeviceSettings().distanceUnits;
        if (du == Sys.UNIT_METRIC) {
            if (dist > 1000) {
                dist = dist/1000;
                unit = "km";
            }
        } else if (du == Sys.UNIT_STATUTE) {
            if (dist > 1608) {
                dist = dist/1608;
                unit = "mi";
            }
        }

        var txt = null;
        if (dist < 100) {
            txt = dist.format("%.1f");
        } else {
            txt = dist.format("%.0f");
        }
        txt += " "+unit;

        return txt;
    }
}
}