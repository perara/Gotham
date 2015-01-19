using System;
using GOTHAM.Gotham.Application.Tools;
using GOTHAM.Gotham.Application;
using GOTHAM.Model;
using System.Collections.Generic;
using GOTHAM.Model;

namespace GOTHAM
{
  class Program
  {



    static void Main(string[] args)
    {
      log4net.Config.XmlConfigurator.Configure();


      // EntityManager.GetSessionFactory().Close();
      // http://www.fakenamegenerator.com/advanced.php?t=country&n%5B%5D=us&c%5B%5D=sw&gen=50&age-min=19&age-max=40
      Console.WriteLine("Welcome");
      using (var session = EntityManager.GetSessionFactory().OpenSession())
      {
        var nodses = session.CreateCriteria<NodeEntity>()
            //.Add(Restrictions.Eq("ip", "192.168.0.2")
            .List<NodeEntity>();
      }
      
      var nodes = new NodeGenerator();
      nodes.GenerateNodes(3, 10000000000000L); // Max value 1000000000000000000L


      // Wait for input
      var input = "";
      while ((input = Console.ReadLine()) != "e")
      {
        Console.WriteLine(Globals.GetInstance().GetID());
      }
    }
  }
}
