using System;
using System.Collections.Generic;
using System.Linq;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using GOTHAM.Tools;
using GOTHAM_TOOLS;
using NHibernate.Linq;

namespace GOTHAM.Application.Tools
{
    /// <summary>
    /// Contains static functions for estimating, converting and generating Nodes. 
    /// </summary>
    public static class NodeGenerator
    {
        private static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // Generates random numbers for bandwidth
        static readonly Random Rnd = new Random();

        // Set the minimum and maximum amount of bandwidth a tier 3 node can have
        private const double ChildMinBw = 0.01;
        private const double ChildMaxBw = 0.2;

        /// <summary>
        /// Produces a general estimate of tier 1 nodes in each country based on population and continent
        /// </summary>
        /// <param name="countries"></param>
        /// <returns></returns>
        public static Dictionary<string, int> EstimateNodes(IEnumerable<CountryEntity> countries)
        {
            var results = new Dictionary<string, int>();
            var total = 0;
            foreach (var country in countries)
            {
                double nodes = 1;
                double temp = country.Population;
                while (temp > 10)
                {
                    temp = (temp - (300000 * nodes));
                    nodes++;
                }
                if (country.Continent == "AF") nodes = (nodes * 0.5);
                else if (country.Continent == "AS") nodes = (nodes * 0.8);
                else if (country.Continent == "SA") nodes = (nodes * 0.8);

                country.Nodes = (int)nodes;
                total += (int)nodes;
                Log.Info(country.Name + " got " + (int)nodes + " nodes");
                results.Add(country.CountryCode, (int)nodes);
            }
            Log.Info("Total of " + total + " locations");
            return results;
        }

        /// <summary>
        /// Converts a list of Locations into Nodes
        /// </summary>
        /// <param name="locations"></param>
        /// <returns></returns>
        public static List<NodeEntity> ConvertLocToNode(IEnumerable<LocationEntity> locations)
        {
            var nodes = new List<NodeEntity>();

            locations.ToList()
                .ForEach(x => nodes.Add(
                    new NodeEntity(x.Name, x.Countrycode, new TierEntity() { Id = 1 }, x.Lat, x.Lng)));

            return nodes;
        }

        /// <summary>
        /// Generates nodes from random cities of the specified country.
        /// Dictionary containing [Country Code] and [Quantity to generate]
        /// </summary>
        /// <param name="nodeEstimate"></param>
        /// <returns></returns>
        public static List<LocationEntity> GenerateFromEstimate(Dictionary<string, int> nodeEstimate)
        {
            var locations = new List<LocationEntity>();

            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                foreach (var item in nodeEstimate)
                {
                    var quantity = item.Value;
                    var cities = session.Query<LocationEntity>()
                        .Where(x => x.Countrycode == item.Key)
                        .OrderBy(x => x.Random)
                        .Take(quantity)
                        .ToList();

                    locations.AddRange(cities);

                    Log.Info(item.Key + ": " + item.Value);

                }
            }// End session
            return locations;
        }

        /// <summary>
        /// Make new node (For testing)
        /// </summary>
        /// <param name="tier"></param>
        /// <returns></returns>
        private static NodeEntity NewRandomNode(TierEntity tier)
        {
            var node = new NodeEntity("test", "Flette", tier, Rnd.Next(Globals.GetInstance().MapMax.X), Rnd.Next(Globals.GetInstance().MapMax.Y));

            return node;
        }


        /// <summary>
        /// Generates nodes with the specific amount of siblings
        /// </summary>
        /// <param name="siblings"></param>
        /// <param name="totBandwidth"></param>
        public static void GenerateNodes(int siblings, long totBandwidth)
        {
            var nodes = new List<NodeEntity>();
            //var cables = new List<CableEntity>();

            // Generate Tier 2 Nodes
            for (var i = 0; i < siblings; i++)
            {

                // Create a tier 2 Node
                var node = NewRandomNode(new TierEntity { Id = 2 });
                node.Cables = new List<CableEntity>();
                node.Bandwidth = totBandwidth;
                nodes.Add(node);

                long bwCounter = 0;

                // Check if total child bandwidth exeedes parent bandwidth
                while (bwCounter < node.Bandwidth)
                {
                    // Make bandwidth cap for child and add to BW counter
                    var bwCap = LongRandom.Next((long)(node.Bandwidth * ChildMinBw), (long)(node.Bandwidth * ChildMaxBw));
                    bwCap = (bwCap + 50) / 1000 * 1000;
                    bwCounter += bwCap;

                    // Create new Tier 3 Node
                    var childNode = NewRandomNode(new TierEntity() { Id = 3 });
                    childNode.Cables = new List<CableEntity>();

                    // Add ChildNode to parentNode
                    node.GetSiblings().Add(childNode);

                    // Add a new Cable Beetwen nodes
                    

                } // Tier 3 End
            } // Tier 2 End


            // Iterate through tier 2 nodes
            foreach (var node in nodes)
            {
                var nodeBandwidth = node.Bandwidth;

                Log.Info("\n");
                Log.Info(node.Lat + " - " + node.Lng + " - Pri: " + node.Priority + " Bandwidth: " + Globals.GetInstance().BwSuffix(node.Bandwidth));

                // Iterate through each of the Tier 3 siblings
                foreach (var sibling in node.GetSiblings())
                {
                    var firstOrDefault = node.Cables.FirstOrDefault(x => x.Nodes[0] == sibling);
                    if (firstOrDefault == null) continue;
                    var siblBandwidth = firstOrDefault.Capacity;
                    Log.Info("\t" + sibling.Lat + " - " + sibling.Lng + " - Pri: " + sibling.Priority + " Cable Cap: " + Globals.GetInstance().BwSuffix(siblBandwidth));
                    nodeBandwidth -= siblBandwidth;
                }
                Log.Info("Bandwidth remaining: " + nodeBandwidth);
            }
        }

        public static void FixSeaNodes()
        {
            var work = new UnitOfWork();
            var nodeRepository = work.GetRepository<NodeEntity>();
            var seaNodes = nodeRepository.FilterBy(x => x.Tier.Id == 4).ToList();
            work.Dispose();

            var newSeaNodes = new List<NodeEntity>();

            foreach (var node in seaNodes)
            {
                var tempNode = node;
                var existing = newSeaNodes.Where((x => x.Name == tempNode.Name && x.CountryCode == tempNode.CountryCode)).FirstOrDefault();

                if (existing == null)
                {
                    var newNode = new NodeEntity(node.Name, node.CountryCode, node.Tier, node.Lat, node.Lng);
                    newNode.Priority = 1;
                    newSeaNodes.Add(newNode);
                }
                else
                    foreach (var part in node.Cables)
                        existing.Cables = new List<CableEntity> {part};
            }

            work = new UnitOfWork();
            var cableRepository = work.GetRepository<NodeEntity>();
            cableRepository.Add(newSeaNodes);
            work.Dispose();

            Log.Info("Fixed " + newSeaNodes.Count + " sea nodes");
        }

        public static void FixNodeCountries()
        {
            // Start work
            var work = new UnitOfWork();

            // Fetch repositories
            var nodeRepository = work.GetRepository<NodeEntity>();
            var countryRepository = work.GetRepository<NodeEntity>();


            var nodes = nodeRepository.All().ToList();
            var countries = countryRepository.All().ToList();

            foreach (var node in nodes)
            {
                var exists = countries.FirstOrDefault(x => x.Name == node.CountryCode);
                node.CountryCode = (exists != null) ? exists.CountryCode : node.CountryCode.ToUpper();
            }

            // Save Nodes
            countryRepository.Add(nodes);

            // Dispose
            work.Dispose();

            Log.Info("Fixed " + nodes.Count + " nodes");
        }
    }
}
