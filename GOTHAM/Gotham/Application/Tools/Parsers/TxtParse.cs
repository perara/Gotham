using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Tools;
using GOTHAM.Model;
using GOTHAM.Model.Tools;
using Newtonsoft.Json;
using GOTHAM.Gotham.Application.Tools.Objects;
using GOTHAM.Tools.Cache;

namespace GOTHAM.Tools
{
    /// <summary>
    /// This class contains static functions for parsing text to objects and vice versa.
    /// After converting to objects the function writes the new objects to the database.
    /// </summary>
    public class TxtParse
    {
        public static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Writes a list of locations to file
        /// countrycode,name,latitude,longitude
        /// </summary>
        /// <param name="locations"></param>
        /// <param name="path"></param>
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

        /// <summary>
        /// Text parsing for type 1 location format
        /// contrycode, name2, name, ?, ?, lat, lng
        /// </summary>
        /// <param name="path"></param>
        public static void FromFile1(string path)
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

            DBTool.WriteList(locations);
        }

        /// <summary>
        /// Text parsing for type 2 location format
        /// name(0), lat(1), lng(2)
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
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

        
        /// <summary>
        /// Text parsing for type 3 location format (GoogleMaps Javascript sea nodes)
        /// contrycode(0), name(1), lat(2), lng(3)
        /// </summary>
        /// <param name="path"></param>
        public static void FromFile3(string path)
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

                node.countryCode = segment[0];
                node.name = segment[1];
                node.lat = coord.lat;
                node.lng = coord.lng;
                node.tier = new TierEntity() { id = 4 };
                nodes.Add(node);

            }

            DBTool.WriteList(nodes);
        }

        /// <summary>
        /// Text parsing for type 3 location format (GoogleMaps Javascript sea cables)
        /// name, capacity, url1, url2,distance, 0, 0, inservice, precise, notes, bound1lng, bount1lat, bound2.lng, bound2.lat, point, point, point, ++point++
        /// </summary>
        /// <param name="path"></param>
        /// <param name="output"></param>
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
                    cable.type = new CableTypeEntity() { id = 0 };
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
                    var cablepart = new CablePartEntity(cables.Last(), cable_part_counter++, Double.Parse(partLocations[i + 1]), Double.Parse(partLocations[i]));

                    cable_parts.Add(cablepart);
                }
                cable_part_counter = 0;
            }

            DBTool.WriteList(cables);
            DBTool.WriteList(cable_parts);
        }

        // Text parsing for type 3 location format (GoogleMaps Javascript sea nodes)
        // countrycode(0), contrycode 2(1), countrynumber(2), countrycode 3(3), country(4), capital(5), size(6), population(7), continent(8)
        public static void FromFile5(string path, string output = null)
        {

            // Read files to string-list and make empty locaions list
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);
            var countries = new List<CountryEntity>();

            foreach (var line in lines)
            {
                var country = new CountryEntity();
                var segment = line.Split(',');
                if (segment.Length != 9) throw new Exception("Inconsistent string detected at line: " + line);

                country.name = segment[4];
                country.countryCode = segment[0];
                country.countryCodeExt = segment[1];
                country.population = Int32.Parse(segment[7]);
                country.size = Double.Parse(segment[6]);
                country.continent = segment[8];

                countries.Add(country);

            }

            DBTool.WriteList(countries);

        }

        /// <summary>
        /// Text parsing for type 3 location format (GoogleMaps Javascript sea nodes)
        /// countrycode(0), contrycode 2(1), countrynumber(2), countrycode 3(3), country(4), capital(5), size(6), population(7), continent(8)
        /// </summary>
        /// <param name="path"></param>
        /// <param name="output"></param>
        public static void FromFile6(string path, string output = null)
        {

            // Read files to string-list and make empty locaions list
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);
            var countries = new List<CountryEntity>();

            foreach (var line in lines)
            {
                var country = new CountryEntity();
                var segment = line.Split(',');
                if (segment.Length != 9) throw new Exception("Inconsistent string detected at line: " + line);

                country.name = segment[4];
                country.countryCode = segment[0];
                country.countryCodeExt = segment[1];
                country.population = Int32.Parse(segment[7]);
                country.size = Double.Parse(segment[6]);
                country.continent = segment[8];

                countries.Add(country);

            }

            DBTool.WriteList(countries);
        }

        /// <summary>
        /// Convert json string to a list of NodeJSON objects (not the same as NodeEntity)
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static List<NodeJSON> JSONToNodes(string path)
        {
            var json = System.IO.File.ReadAllText(path);
            var nodeList = JsonConvert.DeserializeObject<List<NodeJSON>>(json);
            return nodeList;
        }


        /// <summary>
        /// Import nodes from json. Requires country, name, lat, lng
        /// </summary>
        /// <param name="jnodes"></param>
        public static void FromJSON1(List<NodeJSON> jnodes)
        {
            var countries = CacheEngine.Countries;
            var nodes = new List<NodeEntity>();

            foreach (var item in jnodes)
            {
                var node = new NodeEntity();

                node.countryCode = item.country;
                node.name = item.name;
                node.lat = Double.Parse(item.coordinates.latitude);
                node.lng = Double.Parse(item.coordinates.longitude);
                node.tier = new TierEntity() { id = 1 };

                DBTool.Write(node);
            }
        }
    }
}
