using System;
using GOTHAM.Gotham.Application.Tools;
using GOTHAM.Gotham.Application;
using GOTHAM.Gotham.Application.Model;
using System.Collections.Generic;

namespace GOTHAM
{
    class Program
    {

        

        static void Main(string[] args)
        {
            // EntityManager.GetSessionFactory().Close();
            // http://www.fakenamegenerator.com/advanced.php?t=country&n%5B%5D=us&c%5B%5D=sw&gen=50&age-min=19&age-max=40
            Console.WriteLine("Welcome");

            //using (var session = EntityManager.GetSessionFactory().OpenSession())
            //{
            //      var nodses = session.CreateCriteria<NodeEntity>()
            //          .List<NodeEntity>();

            //}

            var nodes = new NodeGenerator();
            nodes.GenerateNodes(3, 10);
            

            // Wait for input
            var input = "";
            while ((input = Console.ReadLine()) != "e")
            {
                Console.WriteLine(Globals.GetInstance().GetID());
            }
        }
    }
}
