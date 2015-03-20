using System;
using System.Diagnostics.CodeAnalysis;

namespace GOTHAM_TOOLS
{
    public class Coordinate
    {

        public static LatLng NewLatLng()
        {
            return new LatLng();
        }

        public static LatLng NewLatLng(double lat, double lng)
        {
            return new LatLng(lat, lng);
        }


        public static Polar NewPolar()
        {
            return new Polar();
        }

        public static Polar NewPolar(int latDeg, int latMin, int latSec, int lngDeg, int lngMin, int lngSec)
        {
            return new Polar(latDeg, latMin, latSec, lngDeg, lngMin, lngSec);
        }



        public class LatLng : BaseCoordinate
        {
            public double Lat { get; private set; }
            public double Lng { get; private set; }

            public LatLng()
            {
            }

            public LatLng(double lat, double lng)
            {
                Lat = lat;
                Lng = lng;
            }

            private Polar ToPolar()
            {
                var latDeg = Lat;
                var latMin = 60*(Lat - latDeg);
                var latSec = 3600*(Lat - latDeg - latMin/60);

                var lngDeg = Lng;
                var lngMin = 60*(Lng - lngDeg);
                var lngSec = 3600*(Lng - lngDeg - lngMin/60);

                return new Polar(latDeg, (int) latMin, (int) latSec, lngDeg, (int) lngMin, (int) lngSec);
            }

            public override object Convert()
            {
                return ToPolar();
            }

            public LatLng ToRadians()
            {
                var radLat = (Math.PI/180)*Lat;
                var radLng = (Math.PI/180)*Lng;
                return new LatLng(radLat, radLng);
            }
        }


        public abstract class BaseCoordinate
        {

            public virtual Object Convert()
            {
                return null;
            }

        }

        public class Polar : BaseCoordinate
        {
            private double LngDeg { get; set; }
            private int LngMin { get; set; }
            private int LngSec { get; set; }
            private double LatDeg { get; set; }
            private int LatMin { get; set; }
            private int LatSec { get; set; }

            public Polar()
            {
            }

            public Polar(double latDeg, int latMin, int latSec, double lngDeg, int lngMin, int lngSec)
            {
                LngDeg = lngDeg;
                LngMin = lngMin;
                LngSec = lngSec;
                LatDeg = latDeg;
                LatMin = latMin;
                LatSec = latSec;
            }

            [SuppressMessage("ReSharper", "PossibleLossOfFraction")]
            private LatLng ToLatLng()
            {
                var lat = (LatDeg) + LatMin/60 + (LatSec)/3600;
                var lng = (LngDeg) + (LngMin)/60 + (LngSec)/3600;
                return new LatLng(lat, lng);
            }

            public override object Convert()
            {
                return ToLatLng();
            }

        }
    }
}
