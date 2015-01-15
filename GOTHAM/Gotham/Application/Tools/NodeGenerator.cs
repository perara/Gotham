using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Gotham.Application.Model;

namespace GOTHAM.Gotham.Application.Tools
{
    class NodeGenerator
    {
        static Random rnd = new Random();

        public void GenerateNodes(int tier2, int tier3)
        {
            var nodes = new List<NodeEntity>();

            for (int i = 0; i < tier2; i++)
            {
                NodeEntity node = NewNode(2);

                for (int j = 0; j < tier3; j++)
                {
                    var childNode = NewNode(3);
                    var cable = NewCable(node, childNode, 100);
                    node.siblings.Add(childNode);
                }

                nodes.Add(node);
            }

            foreach (var node in nodes)
            {
                Console.WriteLine(node.latitude + " - " + node.longditude + " - Pri: " + node.priority);
                foreach (var sibling in node.siblings)
                {
                    Console.WriteLine("\t" + sibling.latitude + " - " + sibling.longditude + " - Pri: " + sibling.priority + " Cable Cap: " );
                }
            }
        }


        private static NodeEntity NewNode(int tier)
        {
            var node = new NodeEntity();

            node.latitude = rnd.Next(Globals.GetInstance().mapMax.X);
            node.longditude = rnd.Next(Globals.GetInstance().mapMax.Y);
            node.name = "Flette";
            node.priority = rnd.Next(10);
            TierEntity tiers = new TierEntity();
            tiers.id = tier;

            node.tier = tiers;
            node.siblings = new List<NodeEntity>();

            return node;
        }

        private static CableEntity NewCable(NodeEntity node1, NodeEntity node2, int bandwidth)
        {
            var cable = new CableEntity();

          var cableType = new CableTypeEntity();
          cableType.id = 0;


            cable.bandwidth = bandwidth;
            //cable.priority = 1;
            cable.quality = 2;
            cable.type = cableType;

            return cable;
        }
    }
}
