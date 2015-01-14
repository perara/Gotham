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

        public NodeGenerator()
        {
            var nodes = new List<NodeEntity>();

            for (int i = 0; i < 3; i++)
            {
                NodeEntity node = GenerateNode(2);
                for (int j = 0; j < 10; j++)
                {
                    var childNode = GenerateNode(3);
                    node.siblings.Add(childNode);
                }
                nodes.Add(node);
            }

            foreach (var node in nodes)
            {
                Console.WriteLine(node.geoPosX + " - " + node.geoPosY + " - Pri: " + node.priority);
                foreach (var sibling in node.siblings)
                {
                    Console.WriteLine("\t" + sibling.geoPosX + " - " + sibling.geoPosY + " - Pri: " + sibling.priority);
                }
            }
        }


        public static NodeEntity GenerateNode(int tier)
        {

            NodeEntity node = new NodeEntity();

            node.geoPosX = rnd.Next(Globals.GetInstance().mapMax.X);
            node.geoPosY = rnd.Next(Globals.GetInstance().mapMax.Y);
            node.name = "Flette";
            node.priority = rnd.Next(10);
            node.tier = tier;
            node.siblings = new List<NodeEntity>();

            return node;
        }

    }
}
