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
using GOTHAM.Gotham.Application.Tools;

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
            //      var nodes = session.CreateCriteria<NodeEntity>().List<NodeEntity>();
            //}

            var gen = new NodeGenerator();
            

            // Wait for input
            var input = "";
            while ((input = Console.ReadLine()) != "e")
            {
                Console.WriteLine(Globals.GetInstance().GetID());
            }
        }
    }
}
