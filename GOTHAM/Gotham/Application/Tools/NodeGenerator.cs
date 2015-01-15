using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Gotham.Application.Model;

namespace GOTHAM.Gotham.Application.Tools
{
    public class NodeGenerator
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        static Random rnd = new Random();
        

        public void GenerateNodes(int tier2, int tier3)
        {
            var nodes = new List<NodeEntity>();
            //var cables = new List<CableEntity>();

            // Generate Tier 2 Nodes
            for (int i = 0; i < tier2; i++)
            {

                // Create a tier 2 Node
                NodeEntity node = NewNode(2);
                node.cables = new List<CableEntity>();
                node.bandwidth = 100000;
                nodes.Add(node);

                int bwCounter = 0;

                // Check if total child bandwidth exeedes parent bandwidth
                while (bwCounter < node.bandwidth)
                {
                    // Make bandwidth cap for child and add to BW counter
                    var bwCap = rnd.Next((int)(node.bandwidth * 0.2));
                    bwCounter += bwCap;

                    // Create new Tier 3 Node
                    var childNode = NewNode(3);
                    childNode.cables = new List<CableEntity>();

                    // Add ChildNode to parentNode
                    node.siblings.Add(childNode);

                    // Add a new Cable Beetwen nodes
                    var cable = NewCable(node, childNode, bwCap);
                    //cables.Add(cable);

                } // Tier 3 End
            } // Tier 2 End


            // Iterate through tier 2 nodes
            foreach (var node in nodes)
            {
                var nodeBandwidth = node.bandwidth;

                log.Info("\n");
                log.Info(node.geoPosX + " - " + node.geoPosY + " - Pri: " + node.priority + " Bandwidth: " + node.bandwidth);


                // Iterate through each of the Tier 3 siblings
                foreach (var sibling in node.siblings)
                {
                    var siblBandwidth = node.cables.FirstOrDefault(x => x.node2 == sibling).bandwidth;
                    log.Info("\t" + sibling.geoPosX + " - " + sibling.geoPosY + " - Pri: " + sibling.priority + " Cable Cap: " + siblBandwidth);
                    nodeBandwidth -= siblBandwidth;
                }
                log.Info("Bandwidth remaining: " + nodeBandwidth);
            }
        }

        // Make new node
        // TODO Get relevant data
        private static NodeEntity NewNode(int tier)
        {
            var node = new NodeEntity();

            node.geoPosX = rnd.Next(Globals.GetInstance().mapMax.X);
            node.geoPosY = rnd.Next(Globals.GetInstance().mapMax.Y);
            node.name = "Flette";
            node.priority = rnd.Next(10);
            node.tier = tier;
            node.siblings = new List<NodeEntity>();

            return node;
        }

        // Make new cables
        // TODO Get relevant data
        private static CableEntity NewCable(NodeEntity node1, NodeEntity node2, int bandwidth)
        {
            var cable = new CableEntity();

            cable.node1 = node1;
            cable.node2 = node2;
            cable.bandwidth = bandwidth;
            //cable.priority = 1;
            cable.quality = 2;
            cable.type = 4;

            // Refference this cable in each node
            node1.cables.Add(cable);
            node2.cables.Add(cable);

            return cable;
        }
    }
}
