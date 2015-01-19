using System;
using GOTHAM.Gotham.Application.Tools;
using GOTHAM.Model;
using GOTHAM.Gotham.API;

namespace GOTHAM
{
  class Program
  {
    private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);


    static void Main(string[] args)
    {
      //
      // LOG4NET configuration
      //
      log4net.Config.XmlConfigurator.Configure();

      //
      // ServiceStack API Server
      //
      ServiceStackConsoleHost.Start();
     




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
