using System;
using GOTHAM_TOOLS;
using NUnit.Framework;

namespace GOTHAM_TESTS.Tools
{
    [TestFixture]
    public class CoordinateTest
    {
        private const double StartLat = 56.2915;
        private const double StartLng = -40.24914;

        [Test]
        public void TEST_CheckCoordinatePrecision()
        {

            Coordinate.BaseCoordinate coord = Coordinate.NewLatLng(StartLat, StartLng);
            for (int i = 0; i < 1000; i++)
            {
                coord = (Coordinate.BaseCoordinate)coord.Convert();
                Console.WriteLine(coord.GetType());
            }

            Coordinate.LatLng endCoord = (Coordinate.LatLng)coord;
            double endLat = endCoord.Lat;
            double endLng = endCoord.Lng;

            // Check that Latitude is equal;
            Assert.AreEqual(StartLat, endLat);
            Assert.AreEqual(StartLng, endLng);





        }





    }
}
