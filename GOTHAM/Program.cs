using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Cache;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using GOTHAM.Gotham.Application;
using NHibernate;
using GOTHAM.Gotham.Application.Model;

namespace GOTHAM
{
    class Program
    {

        static Random rnd = new Random();

        static void Main(string[] args)
        {
            // EntityManager.GetSessionFactory().Close();
            // http://www.fakenamegenerator.com/advanced.php?t=country&n%5B%5D=us&c%5B%5D=sw&gen=50&age-min=19&age-max=40
            Console.WriteLine("Welcome");
            //using (var session = EntityManager.GetSessionFactory().OpenSession())
            //{
            //      var nodes = session.CreateCriteria<NodeEntity>().List<NodeEntity>();
            //}


            // Wait for input
            var input = "";
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
            
            foreach(var node in nodes)
            {
                Console.WriteLine(node.geoPosX + " - " + node.geoPosY + " - Pri: " + node.priority);
            }

            while ((input = Console.ReadLine()) != "e")
            {

                Console.WriteLine(Globals.GetInstance().GetID());
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
            node.siblings = new ISet<NodeEntity>();

            return node;
        }
    }
}
