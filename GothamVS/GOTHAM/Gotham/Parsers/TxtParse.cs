using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using Gotham.Tools;
using Gotham.Model;
using GOTHAM.Repository.Abstract;

namespace Gotham.Application.Parsers
{
    /// <summary>
    /// This class contains static functions for parsing text to objects and vice versa.
    /// After converting to objects the function writes the new objects to the database.
    /// </summary>
    public static class TxtParse
    {
        public static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static void setUsaCulture()
        {
            var customCulture = (CultureInfo)System.Threading.Thread.CurrentThread.CurrentCulture.Clone();
            customCulture.NumberFormat.NumberDecimalSeparator = ".";
            System.Threading.Thread.CurrentThread.CurrentCulture = customCulture;
        }


        /// <summary>
        /// Writes a list of locations to file
        /// countrycode,name,latitude,longitude
        /// </summary>
        /// <param name="locations"></param>
        /// <param name="path"></param>
        public static void LocsToFile(IEnumerable<LocationEntity> locations, string path)
        {
            var file = File.AppendText(path);
            var sortedLocations = locations.OrderBy(x => x.Countrycode).ThenBy(x => x.Name);

            foreach (var str in sortedLocations.Select(location => location.Countrycode + "," + location.Name + "," + location.Lat + "," + location.Lng))
                file.WriteLine(str);
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
                var coord = Coordinate.NewLatLng(
                    double.Parse(segment[5], CultureInfo.InvariantCulture),
                    double.Parse(segment[6], CultureInfo.InvariantCulture));

                location.Countrycode = segment[0];
                location.Name = segment[2];
                location.Lat = coord.Lat;
                location.Lng = coord.Lng;
                locations.Add(location);
            }

            var work = new UnitOfWork();
            work.GetRepository<LocationEntity>().Add(locations);
            work.Dispose();
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
                var coord = Coordinate.NewLatLng(
                    double.Parse(segment[1], CultureInfo.InvariantCulture),
                    double.Parse(segment[2], CultureInfo.InvariantCulture));

                node.Name = segment[0];
                node.Tier = new TierEntity() { Id = 1 };
                node.Lat = coord.Lat;
                node.Lng = coord.Lng;
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
                var coord = Coordinate.NewLatLng(
                    double.Parse(segment[2]),
                    double.Parse(segment[3]));

                node.CountryCode = segment[0];
                node.Name = segment[1];
                node.Lat = coord.Lat;
                node.Lng = coord.Lng;
                node.Tier = new TierEntity() { Id = 4 };
                nodes.Add(node);

            }

            var work = new UnitOfWork();
            work.GetRepository<NodeEntity>().Add(nodes);
            work.Dispose();
        }

        /// <summary>
        /// Text parsing for greg's node location format (GoogleMaps Javascript sea nodes)
        /// name(0), country(1), lng(2), lat(3)
        /// </summary>
        /// <param name="path"></param>
        public static void ParseGregNodes(string path)
        {
            setUsaCulture();

            // Read files to string-list and make empty locaions list
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);
            var nodes = new List<NodeEntity>();

            foreach (var line in lines)
            {
                var tmp = "";
                var node = new NodeEntity();
                var segments = line.Split(',');
                var list = segments.Reverse().ToList();
                var lat = list[0];
                var lng = list[1];
                var countryCode = list[2];
                list.RemoveRange(0,3);
                list.Reverse();

                var name = list.ToList().Aggregate("", (current, segment) => current + (segment + ", "));

                var coord = Coordinate.NewLatLng(
                    double.Parse(lat),
                    double.Parse(lng));

                node.CountryCode = countryCode;
                node.Name = name.Substring(0, name.Length -2);
                node.Lat = coord.Lat;
                node.Lng = coord.Lng;
                node.Tier = new TierEntity { Id = 4 };
                node.Priority = 0;
                node.Bandwidth = 0;

                if (string.IsNullOrWhiteSpace(node.Name)) node.Name = "Unknown";
                if (string.IsNullOrWhiteSpace(node.CountryCode)) node.CountryCode = "XX";

                nodes.Add(node);

                Debug.WriteLine("Added sea node");

            }

            var work = new UnitOfWork();
            work.GetRepository<NodeEntity>().Add(nodes);
            work.Dispose();
        }

        /// <summary>
        /// Text parsing for type 3 location format (GoogleMaps Javascript sea cables)
        /// name, capacity, url1, url2,distance, 0, 0, inservice, precise, notes, bound1lng, bount1lat, bound2.lng, bound2.lat, point, point, point, ++point++
        /// </summary>
        /// <param name="path"></param>
        public static void FromFile4(string path)
        {
            // Read file and split lines into list 
            var file = File.ReadAllLines(path, Encoding.Default);
            var lines = new List<string>(file);

            // Make list for cables and cableparts. Cableparts contains 1 entry per line. Cables contains 1 entry per cable
            var cables = new List<CableEntity>();
            var cableParts = new List<CablePartEntity>();
            var cablePartCounter = 0;

            // Iterate through all cables
            foreach (var line in lines)
            {
                var segments = line.Split(',').ToList();

                // Are we processing the same cable or is this a new cable? If yes, generate new cable entity
                if (cables.Count == 0 || segments[0] != cables.Last().Name)
                {
                    var cable = new CableEntity
                    {
                        Name = segments[0],
                        Priority = 0,
                        Capacity = Double.Parse(segments[1]),
                        Type = new CableTypeEntity() { Id = 0 },
                        Distance = Double.Parse(segments[4]),
                        Year = Int32.Parse(segments[7])
                    };

                    cablePartCounter = 0;

                    cables.Add(cable);
                }

                // Collect info and cablepart coordinates and split into seperate lists
                var partLocations = segments.GetRange(14, segments.Count - 14);

                for (var i = 0; i < partLocations.Count; i += 2)
                {
                    var cablepart = new CablePartEntity(cables.Last(), cablePartCounter++, Double.Parse(partLocations[i + 1]), Double.Parse(partLocations[i]));

                    cableParts.Add(cablepart);
                }
                cablePartCounter = 0;
            }

            var work = new UnitOfWork();
            work.GetRepository<CableEntity>().Add(cables);
            work.GetRepository<CablePartEntity>().Add(cableParts);
            work.Dispose();
        }

        /// <summary>
        /// Text parsing for type 3 location format (GoogleMaps Javascript sea nodes)
        /// countrycode(0), contrycode 2(1), countrynumber(2), countrycode 3(3), country(4), capital(5), size(6), population(7), continent(8)
        /// </summary>
        /// <param name="path"></param>
        public static void FromFile5(string path)
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

                country.Name = segment[4];
                country.CountryCode = segment[0];
                country.CountryCodeExt = segment[1];
                country.Population = Int32.Parse(segment[7]);
                country.Size = Double.Parse(segment[6]);
                country.Continent = segment[8];

                countries.Add(country);

            }

            var work = new UnitOfWork();
            work.GetRepository<CountryEntity>().Add(countries);
            work.Dispose();
        }

        /// <summary>
        /// Text parsing for type 3 location format (GoogleMaps Javascript sea nodes)
        /// countrycode(0), contrycode 2(1), countrynumber(2), countrycode 3(3), country(4), capital(5), size(6), population(7), continent(8)
        /// </summary>
        /// <param name="path"></param>
        public static void FromFile6(string path)
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

                country.Name = segment[4];
                country.CountryCode = segment[0];
                country.CountryCodeExt = segment[1];
                country.Population = Int32.Parse(segment[7]);
                country.Size = Double.Parse(segment[6]);
                country.Continent = segment[8];

                countries.Add(country);

            }

            var work = new UnitOfWork();
            work.GetRepository<CountryEntity>().Add(countries);
            work.Dispose();
        }

        /// <summary>
        /// Convert json string to a list of NodeJSON objects (not the same as NodeEntity)
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        /* public static List<NodeJson> JsonToNodes(string path)
         {
             var json = File.ReadAllText(path);
             var nodeList = JsonConvert.DeserializeObject<List<NodeJson>>(json);
             return nodeList;
         }*/


        /// <summary>
        /// Import nodes from json. Requires country, name, lat, lng
        /// </summary>
        /// <param name="jnodes"></param>
        /*public static void FromJson1(IEnumerable<NodeJson> jnodes)
        {
            foreach (var node in jnodes.Select(item => new NodeEntity
            {
                CountryCode = item.Country,
                Name = item.Name,
                Lat = Double.Parse(item.Coordinates.Latitude),
                Lng = Double.Parse(item.Coordinates.Longitude),
                Tier = new TierEntity() {Id = 1}
            }))
            {
                DbTool.Write(node);
            }
        }*/
    }
}
