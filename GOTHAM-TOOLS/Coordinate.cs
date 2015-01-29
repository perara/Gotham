using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Tools
{
    public class Coordinate
    {

        public static LatLng newLatLng()
        {
            return new LatLng();
        }
        public static LatLng newLatLng(double lat, double lng)
        {
            return new LatLng(lat, lng);
        }


        public static Polar newPolar()
        {
            return new Polar();
        }
        public static Polar newPolar(int latDeg, int latMin, int latSec, int lngDeg, int lngMin, int lngSec)
        {
            return new Polar(latDeg, latMin, latSec, lngDeg, lngMin, lngSec);
        }

        

        public class LatLng : BaseCoordinate
        {
            public double lat { get; set; }
            public double lng { get; set; }

            public LatLng() { }

            public LatLng(double lat, double lng)
            {
                this.lat = lat;
                this.lng = lng;
            }

            public Polar toPolar()
            {
                double latDeg = lat;
                double latMin = 60 * (lat - latDeg);
                double latSec = 3600 * (lat - latDeg - latMin / 60);

                double lngDeg = lng;
                double lngMin = 60 * (lng - lngDeg);
                double lngSec = 3600 * (lng - lngDeg - lngMin / 60);

                return new Polar(latDeg, (int)latMin, (int)latSec, lngDeg, (int)lngMin, (int)lngSec);
            }

            public override object convert()
            {
                return toPolar();
            }
            public LatLng ToRadians()
            {
                var lat = (Math.PI / 180) * this.lat;
                var lng = (Math.PI / 180) * this.lng;
                return new LatLng(lat, lng);
            }
        }


        public abstract class BaseCoordinate
        {

            public virtual Object convert()
            {
                return null;
            }

        }

        public class Polar : BaseCoordinate
        {
            public double LngDeg { get; set; }
            public int LngMin { get; set; }
            public int LngSec { get; set; }
            public double LatDeg { get; set; }
            public int LatMin { get; set; }
            public int LatSec { get; set; }

            public Polar() { }
            public Polar(double latDeg, int latMin, int latSec, double lngDeg, int lngMin, int lngSec)
            {
                this.LngDeg = lngDeg;
                this.LngMin = lngMin;
                this.LngSec = lngSec;
                this.LatDeg = latDeg;
                this.LatMin = latMin;
                this.LatSec = latSec;
            }

            public LatLng toLatLng()
            {
                double Lat = (LatDeg) + (LatMin) / 60 + (LatSec) / 3600;
                double Lng = (LngDeg) + (LngMin) / 60 + (LngSec) / 3600;
                return new LatLng(Lat, Lng);
            }

            public override object convert()
            {
                return toLatLng();
            }

        }

    }


    // 43.565548, 65.345435
    // 24¤ 15' 30", 25¤ 11' 30"



}
