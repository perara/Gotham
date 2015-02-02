using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Model;
using GOTHAM.Tools;
using GOTHAM.Model.Tools;

namespace GOTHAM.Gotham.Application.Tools
{
    public class TxtParse
    {
        // Write locations in list to predefined locations pattern in a file
        public static void LocsToFile(List<LocationEntity> locations, string path)
        {
            var file = File.AppendText(path);
            var sortedLocations = locations.OrderBy(x => x.countrycode).ThenBy(x => x.name);

            foreach (var location in sortedLocations)
            {
                var str = location.countrycode + "," + location.name + "," + location.lat + "," + location.lng;
                file.WriteLine(str);
            }
        }

        // Text parsing for type 1 location format
        // contrycode, name2, name, ?, ?, lat, lng
        public static List<LocationEntity> FromFile1(string path)
        {

            // Read files to string-list and make empty locaions list
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);
            var locations = new List<LocationEntity>();

            foreach (var line in lines)
            {
                var location = new LocationEntity();
                var segment = line.Split(',');
                var coord = Coordinate.newLatLng(
                    double.Parse(segment[5], CultureInfo.InvariantCulture),
                    double.Parse(segment[6], CultureInfo.InvariantCulture));

                location.countrycode = segment[0];
                location.name = segment[2];
                location.lat = coord.lat;
                location.lng = coord.lng;
                locations.Add(location);
            }

            return locations;
        }

        // Text parsing for type 2 location format
        // name, lat, lng
        public static List<NodeEntity> FromFile2(string path)
        {

            // Read files to string-list and make empty locaions list
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);
            var nodes = new List<NodeEntity>();

            foreach (var line in lines)
            {
                var node = new NodeEntity();
                var segment = line.Split(',');
                var coord = Coordinate.newLatLng(
                    double.Parse(segment[1], CultureInfo.InvariantCulture),
                    double.Parse(segment[2], CultureInfo.InvariantCulture));

                node.name = segment[0];
                node.tier = new TierEntity() { id = 1 };
                node.lat = coord.lat;
                node.lng = coord.lng;
                nodes.Add(node);
            }
            return nodes;
        }

        // Text parsing for type 3 location format (GoogleMaps Javascript sea nodes)
        // contrycode, name, lat, lng
        public static List<NodeEntity> FromFile3(string path, string output = null)
        {

            // Read files to string-list and make empty locaions list
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);
            var nodes = new List<NodeEntity>();

            foreach (var line in lines)
            {
                var node = new NodeEntity();
                var segment = line.Split(',');
                var coord = Coordinate.newLatLng(
                    double.Parse(segment[2]),
                    double.Parse(segment[3]));

                node.country = segment[0];
                node.name = segment[1];
                node.lat = coord.lat;
                node.lng = coord.lng;
                node.tier = new TierEntity() { id = 4 };
                nodes.Add(node);

            }
            foreach (var node in nodes)
            { DBTool.Write(node); }

            return nodes;
        }

        // Text parsing for type 3 location format (GoogleMaps Javascript sea cables)
        // name, capacity, url1, url2,distance, 0, 0, inservice, precise, notes, bound1lng, bount1lat, bound2.lng, bound2.lat, point, point, point, ++point++
        public static void FromFile4(string path, string output = null)
        {
            // Read file and split lines into list 
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);

            // Make list for cables and cableparts. Cableparts contains 1 entry per line. Cables contains 1 entry per cable
            var cables = new List<CableEntity>();
            var cable_parts = new List<CablePartEntity>();
            var cable_part_counter = 0;

            // Iterate through all cables
            foreach (var line in lines)
	        {
                var segments = line.Split(',').ToList();
                
                // Are we processing the same cable or is this a new cable? If yes, generate new cable entity
                if (cables.Count == 0 || segments[0] != cables.Last().name)
                {
                    var cable = new CableEntity();
          
                    cable.name = segments[0];
                    cable.priority = 0;
                    cable.capacity = Double.Parse(segments[1]);
                    cable.type = new CableTypeEntity(){id = 0};
                    cable.distance = Double.Parse(segments[4]);
                    cable.year = Int32.Parse(segments[7]);
                    cable_part_counter = 0;

                    cables.Add(cable);
                }

                // Collect info and cablepart coordinates and split into seperate lists
                var cableinfo = segments.GetRange(0, 13);
                var partLocations = segments.GetRange(14, segments.Count - 14);

                for (int i = 0; i < partLocations.Count; i += 2)
                {
                    var cablepart = new CablePartEntity();

                    // TODO Is ID generated if cable is not in database?
                    cablepart.cable = cables.Last();
                    cablepart.number = cable_part_counter++;
                    cablepart.lat = Double.Parse(partLocations[i + 1]);
                    cablepart.lng = Double.Parse(partLocations[i]);
                    cable_parts.Add(cablepart);
                }
                cable_part_counter = 0;
	        }

            foreach (var cable in cables) 
                { DBTool.Write(cable); }
            foreach (var cable_part in cable_parts) 
                { DBTool.Write(cable_part); }
        }


    }
}
