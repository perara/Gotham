using GOTHAM.Model;
using GOTHAM.Model;
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

            Coordinate.BaseCoordinate coord = Coordinate.newLatLng(startLat, startLng);
            for (int i = 0; i < 1000; i++)
            {
                coord = (Coordinate.BaseCoordinate)coord.convert();
                Console.WriteLine(coord.GetType());
            }

            Coordinate.LatLng endCoord = (Coordinate.LatLng)coord;
            double endLat = endCoord.lat;
            double endLng = endCoord.lng;

            // Check that Latitude is equal;
            Assert.AreEqual(startLat, endLat);
            Assert.AreEqual(startLng, endLng);





        }





    }
}
