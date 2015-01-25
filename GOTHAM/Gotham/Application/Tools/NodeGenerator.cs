using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Model;
using GOTHAM.Tools;

namespace GOTHAM.Gotham.Application.Tools
{
    public class NodeGenerator
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // Generates random numbers for bandwidth
        static Random rnd = new Random();

        // Set the minimum and maximum amount of bandwidth a tier 3 node can have
        static double childMinBW = 0.01;
        static double childMaxBW = 0.2;

        // Make new node
        // TODO Get relevant data
        private static NodeEntity NewNode(TierEntity tier)
        {
            var node = new NodeEntity();

            node.latitude = rnd.Next(Globals.GetInstance().mapMax.X);
            node.longitude = rnd.Next(Globals.GetInstance().mapMax.Y);
            node.country = "Flette";
            node.priority = rnd.Next(10);
            node.tier = tier;
            node.siblings = new List<NodeEntity>();

            return node;
        }

        

        public void GenerateNodes(int siblings, long totBandwidth)
        {
            var nodes = new List<NodeEntity>();
            //var cables = new List<CableEntity>();

            // Generate Tier 2 Nodes
            for (int i = 0; i < siblings; i++)
            {

                // Create a tier 2 Node
                NodeEntity node = NewNode(new TierEntity() { id = 2 });
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
                    var childNode = NewNode(new TierEntity() { id = 3 });
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
                log.Info(node.latitude + " - " + node.longitude + " - Pri: " + node.priority + " Bandwidth: " + Globals.GetInstance().BWSuffix(node.bandwidth));

                // Iterate through each of the Tier 3 siblings
                foreach (var sibling in node.siblings)
                {
                    var siblBandwidth = node.cables.FirstOrDefault(x => x.nodes[0] == sibling).capacity;
                    log.Info("\t" + sibling.latitude + " - " + sibling.longitude + " - Pri: " + sibling.priority + " Cable Cap: " + Globals.GetInstance().BWSuffix(siblBandwidth));
                    nodeBandwidth -= siblBandwidth;
                }
                log.Info("Bandwidth remaining: " + nodeBandwidth);
            }
        }
    }
}
