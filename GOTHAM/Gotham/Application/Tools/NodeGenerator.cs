using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NHibernate.Linq;
using GOTHAM.Tools;
using GOTHAM.Model;
using GOTHAM.Model.Tools;

namespace GOTHAM.Tools
{
    /// <summary>
    /// Contains static functions for estimating, converting and generating Nodes. 
    /// </summary>
    public class NodeGenerator
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // Generates random numbers for bandwidth
        static Random rnd = new Random();

        // Set the minimum and maximum amount of bandwidth a tier 3 node can have
        static double childMinBW = 0.01;
        static double childMaxBW = 0.2;

        /// <summary>
        /// Produces a general estimate of tier 1 nodes in each country based on population and continent
        /// </summary>
        /// <param name="countries"></param>
        /// <returns></returns>
        public static Dictionary<string, int> estimateNodes(List<CountryEntity> countries)
        {
            var results = new Dictionary<string, int>();
            var total = 0;
            foreach (var country in countries)
            {
                double nodes = 1;
                double temp = country.population;
                while (temp > 10)
                {
                    temp = (temp - (300000 * nodes));
                    nodes++;
                }
                if (country.continent == "AF") nodes = (nodes * 0.5);
                else if (country.continent == "AS") nodes = (nodes * 0.8);
                else if (country.continent == "SA") nodes = (nodes * 0.8);

                country.nodes = (int)nodes;
                total += (int)nodes;
                log.Info(country.name + " got " + (int)nodes + " nodes");
                results.Add(country.countryCode, (int)nodes);
            }
            log.Info(total);
            return results;
        }

        /// <summary>
        /// Converts a list of Locations into Nodes
        /// </summary>
        /// <param name="locations"></param>
        /// <returns></returns>
        public static List<NodeEntity> convertLocToNode(List<LocationEntity> locations)
        {
            var nodes = new List<NodeEntity>();

            foreach (var loc in locations)
            {
                var node = new NodeEntity(loc.name, loc.countrycode, new TierEntity() { id = 1 }, loc.lat, loc.lng);

                nodes.Add(node);
            }
            return nodes;
        }

        /// <summary>
        /// Generates nodes from random cities of the specified country.
        /// Dictionary containing [Country Code] and [Quantity to generate]
        /// </summary>
        /// <param name="nodeEstimate"></param>
        /// <returns></returns>
        public static List<LocationEntity> generateFromEstimate(Dictionary<string, int> nodeEstimate)
        {
            var rand = new Random();
            var locations = new List<LocationEntity>();

            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {
                    foreach (var item in nodeEstimate)
                    {
                        var country = item.Key;
                        var quantity = item.Value;
                        var cities = session.Query<LocationEntity>()
                            .Where(x => x.countrycode == item.Key)
                            .OrderBy(x => x.Random)
                            .Take(quantity)
                            .ToList();

                        locations.AddRange(cities);

                        log.Info(item.Key + ": " + item.Value);

                    }
                }// End transaction
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
            var node = new NodeEntity("test", "Flette", tier, rnd.Next(Globals.GetInstance().mapMax.X), rnd.Next(Globals.GetInstance().mapMax.Y));

            return node;
        }


        /// <summary>
        /// Generates nodes with the specific amount of siblings
        /// </summary>
        /// <param name="siblings"></param>
        /// <param name="totBandwidth"></param>
        public void GenerateNodes(int siblings, long totBandwidth)
        {
            var nodes = new List<NodeEntity>();
            //var cables = new List<CableEntity>();

            // Generate Tier 2 Nodes
            for (int i = 0; i < siblings; i++)
            {

                // Create a tier 2 Node
                NodeEntity node = NewRandomNode(new TierEntity() { id = 2 });
                node.cables = new List<CableEntity>();
                node.bandwidth = totBandwidth;
                nodes.Add(node);

                long bwCounter = 0;

                // Check if total child bandwidth exeedes parent bandwidth
                while (bwCounter < node.bandwidth)
                {
                    // Make bandwidth cap for child and add to BW counter
                    var bwCap = LongRandom.Next((long)(node.bandwidth * childMinBW), (long)(node.bandwidth * childMaxBW));
                    bwCap = (bwCap + 50) / 1000 * 1000;
                    bwCounter += bwCap;

                    // Create new Tier 3 Node
                    var childNode = NewRandomNode(new TierEntity() { id = 3 });
                    childNode.cables = new List<CableEntity>();

                    // Add ChildNode to parentNode
                    node.siblings.Add(childNode);

                    // Add a new Cable Beetwen nodes
                    var cable = CableGenerator.NewCable(node, childNode, bwCap);

                } // Tier 3 End
            } // Tier 2 End


            // Iterate through tier 2 nodes
            foreach (var node in nodes)
            {
                var nodeBandwidth = node.bandwidth;

                log.Info("\n");
                log.Info(node.lat + " - " + node.lng + " - Pri: " + node.priority + " Bandwidth: " + Globals.GetInstance().BWSuffix(node.bandwidth));

                // Iterate through each of the Tier 3 siblings
                foreach (var sibling in node.siblings)
                {
                    var siblBandwidth = node.cables.FirstOrDefault(x => x.nodes[0] == sibling).capacity;
                    log.Info("\t" + sibling.lat + " - " + sibling.lng + " - Pri: " + sibling.priority + " Cable Cap: " + Globals.GetInstance().BWSuffix(siblBandwidth));
                    nodeBandwidth -= siblBandwidth;
                }
                log.Info("Bandwidth remaining: " + nodeBandwidth);
            }
        }

        public static void fixSeaNodes()
        {
            var seaNodes = Globals.GetInstance().nodes.Where(x => x.tier.id == 4).ToList();
            var newSeaNodes = new List<NodeEntity>();
            var test = new NodeEntity();
            foreach (var node in seaNodes)
            {
                var existing = newSeaNodes.Where((x => x.name == node.name && x.country == node.country)).FirstOrDefault();

                if (existing == null)
                {
                    var newNode = new NodeEntity(node.name, node.country, node.tier, node.lat, node.lng);
                    newSeaNodes.Add(newNode);
                }
                else
                {
                    foreach (var part in node.cables)
                    {
                        existing.cables = new List<CableEntity>();
                        existing.cables.Add(part);
                    }
                }
            }

            DBTool.WriteList(newSeaNodes);

            //DBTool.WriteList(newSeaNodes);
        }
    }
}
