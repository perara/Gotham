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
                Console.WriteLine(node.geoPosX + " - " + node.geoPosY + " - Pri: " + node.priority);
                foreach (var sibling in node.siblings)
                {
                    Console.WriteLine("\t" + sibling.geoPosX + " - " + sibling.geoPosY + " - Pri: " + sibling.priority + " Cable Cap: " );
                }
            }
        }


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

        private static CableEntity NewCable(NodeEntity node1, NodeEntity node2, int bandwidth)
        {
            var cable = new CableEntity();

            cable.bandwidth = bandwidth;
            //cable.priority = 1;
            cable.quality = 2;
            cable.type = 4;

            return cable;
        }
    }
}
