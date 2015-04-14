using System;
using NUnit.Framework;
using Gotham.Tools;

namespace Gotham.Tests.Tools
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
            for (var i = 0; i < 1000; i++)
            {
                coord = (Coordinate.BaseCoordinate)coord.Convert();
                Console.WriteLine(coord.GetType());
            }

            var endCoord = (Coordinate.LatLng)coord;
            var endLat = endCoord.Lat;
            var endLng = endCoord.Lng;

            // Check that Latitude is equal;
            Assert.AreEqual(StartLat, endLat);
            Assert.AreEqual(StartLng, endLng);





        }





    }
}
