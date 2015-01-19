using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Application.Tools
{
    public class Coordinate
    {

        public static LatLngCoordinate newLatLng()
        {
            return new LatLngCoordinate();
        }
        public static LatLngCoordinate newLatLng(double lat, double lng)
        {
            return new LatLngCoordinate(lat, lng);
        }


        public static PolarCoordinate newPolar()
        {
            return new PolarCoordinate();
        }
        public static PolarCoordinate newPolar(int latDeg, int latMin, int latSec, int lngDeg, int lngMin, int lngSec)
        {
            return new PolarCoordinate(latDeg, latMin, latSec, lngDeg, lngMin, lngSec);
        }



        public class LatLngCoordinate : BaseCoordinate
        {
            public double latitude { get; set; }
            public double longditude { get; set; }

            public LatLngCoordinate() { }

            public LatLngCoordinate(double lat, double lng)
            {
                this.latitude = lat;
                this.longditude = lng;
            }

            public PolarCoordinate toPolar()
            {
                double latDeg = latitude;
                double latMin = 60 * (latitude - latDeg);
                double latSec = 3600 * (latitude - latDeg - latMin / 60);

                double lngDeg = longditude;
                double lngMin = 60 * (longditude - lngDeg);
                double lngSec = 3600 * (longditude - lngDeg - lngMin / 60);

                return new PolarCoordinate(latDeg, (int)latMin, (int)latSec, lngDeg, (int)lngMin, (int)lngSec);
            }

            public override object convert()
            {
                return toPolar();
            }
        }


        public abstract class BaseCoordinate
        {

            public virtual Object convert()
            {
                return null;
            }

        }

        public class PolarCoordinate : BaseCoordinate
        {
            public double LngDeg { get; set; }
            public int LngMin { get; set; }
            public int LngSec { get; set; }
            public double LatDeg { get; set; }
            public int LatMin { get; set; }
            public int LatSec { get; set; }

            public PolarCoordinate() { }
            public PolarCoordinate(double latDeg, int latMin, int latSec, double lngDeg, int lngMin, int lngSec)
            {
                this.LngDeg = lngDeg;
                this.LngMin = lngMin;
                this.LngSec = lngSec;
                this.LatDeg = latDeg;
                this.LatMin = latMin;
                this.LatSec = latSec;
            }

            public LatLngCoordinate toLatLng()
            {
                double Lat = (LatDeg) + (LatMin) / 60 + (LatSec) / 3600;
                double Lng = (LngDeg) + (LngMin) / 60 + (LngSec) / 3600;
                return new LatLngCoordinate(Lat, Lng);
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
