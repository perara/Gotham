using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Model;

namespace GOTHAM.Gotham.Application.Tools
{
    public class TxtParse
    {
        public static List<LocationEntity> FromFile(string path)
        {
            
            // Read files to string-list and make empty locaions list
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);
            var locations = new List<LocationEntity>();

            foreach (var line in lines)
            {
                var location = new LocationEntity();
                var l = line.Split(',');
                var coord = Coordinate.newLatLng(
                    double.Parse(l[5], CultureInfo.InvariantCulture),
                    double.Parse(l[6], CultureInfo.InvariantCulture));

                location.countrycode = l[0];
                location.name = l[2];
                location.latitude = coord.latitude;
                location.longitude = coord.longitude;
                locations.Add(location);
            }

            return locations;
        }
    }
}
