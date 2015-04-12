using System;

namespace Gotham.Tools
{
    public static class GeoTool
    {
        public static double GetDistance(Coordinate.LatLng pos1, Coordinate.LatLng pos2)
        {
            const double r = 6371.0; // km
            var φ1 = pos1.ToRadians().Lat;
            var φ2 = pos2.ToRadians().Lat;
            var δφ = (pos2.ToRadians().Lat - pos1.ToRadians().Lat);
            var δλ = (pos2.ToRadians().Lng - pos1.ToRadians().Lng);

            var a = Math.Sin(δφ / 2.0) * Math.Sin(δφ / 2.0) +
                    Math.Cos(φ1) * Math.Cos(φ2) *
                    Math.Sin(δλ / 2.0) * Math.Sin(δλ / 2.0);
            var c = 2.0 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1.0 - a));

            var d = r * c;
            return d;
        }
    }
}
