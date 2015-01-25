
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Tools
{
    public class GeoTool
    {
        public static double GetDistance(Coordinate.LatLng pos1, Coordinate.LatLng pos2)
        {
            var R = 6371.0; // km
            var φ1 = pos1.ToRadians().latitude;
            var φ2 = pos2.ToRadians().latitude;
            var Δφ = (pos2.ToRadians().latitude - pos1.ToRadians().latitude);
            var Δλ = (pos2.ToRadians().longitude - pos1.ToRadians().longitude);

            var a = Math.Sin(Δφ / 2.0) * Math.Sin(Δφ / 2.0) +
                    Math.Cos(φ1) * Math.Cos(φ2) *
                    Math.Sin(Δλ / 2.0) * Math.Sin(Δλ / 2.0);
            var c = 2.0 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1.0 - a));

            var d = R * c;
            return d;
        }
    }
}
