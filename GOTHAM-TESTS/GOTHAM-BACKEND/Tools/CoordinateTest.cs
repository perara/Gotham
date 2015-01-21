using GOTHAM.Gotham.Application.Tools;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Tests.Tools
{
    [TestFixture]
    public class CoordinateTest
    {

        double startLat = 56.2915;
        double startLng = -40.24914;

        [Test]
        public void TEST_CheckCoordinatePrecision()
        {

            GOTHAM.Gotham.Application.Tools.Coordinate.BaseCoordinate coord = Coordinate.newLatLng(startLat, startLng);
            for (int i = 0; i < 1000; i++)
            {
                coord = (GOTHAM.Gotham.Application.Tools.Coordinate.BaseCoordinate)coord.convert();
                Console.WriteLine(coord.GetType());
            }

            Coordinate.LatLngCoordinate endCoord = (Coordinate.LatLngCoordinate)coord;
            double endLat = endCoord.latitude;
            double endLng = endCoord.longitude;

            // Check that Latitude is equal;
            Assert.AreEqual(startLat, endLat);
            Assert.AreEqual(startLng, endLng);





        }





    }
}
