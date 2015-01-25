using System;
using GOTHAM.Gotham.Application.Tools;
using GOTHAM.Model;
using GOTHAM.Model.Tools;
using GOTHAM.Gotham.API;
using System.Collections.Generic;
using GOTHAM.Tools;
using System.Globalization;

namespace GOTHAM
{
    class Program
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);


        static void Main(string[] args)
        {
            // ServiceStack API Server
            ServiceStackConsoleHost.Start();

            //Initiate logging class
            log4net.Config.XmlConfigurator.Configure();

            // Change decimal seperator to . instead of ,
            System.Globalization.CultureInfo customCulture = (System.Globalization.CultureInfo)System.Threading.Thread.CurrentThread.CurrentCulture.Clone();
            customCulture.NumberFormat.NumberDecimalSeparator = ".";
            CultureInfo.DefaultThreadCurrentCulture = customCulture;


            var nodes = new List<NodeEntity>();
            TxtParse.FromFile4("C:\\temp\\SeaCableCables.txt");

            //TxtParse.LocsToFile(locations, "C:\\temp\\SeaCableCablesTestOutput.txt");

            log.Info(nodes.Count);
            log.Info("DOG FINISH");
            Console.ReadLine();


            //System.Threading.Thread.CurrentThread.CurrentCulture = customCulture;
            //
            // LOG4NET configuration
            //
            //var locations = TxtParse.FromFile2("C:\\temp\\tier2.txt");
            //var nodes = new List<NodeEntity>();




            //var cables = new List<CableEntity>();

            //using (var session = EntityManager.GetSessionFactory().OpenSession())
            //{

            //    nodes = (List<NodeEntity>)session.CreateCriteria<NodeEntity>().List<NodeEntity>();
            //    cables = (List<CableEntity>)session.CreateCriteria<CableEntity>().List<CableEntity>();

            //}


            //foreach (var location in locations)
            //{
            //    nodes.Add(new NodeEntity()
            //    {
            //        name = location.name,
            //        longitude = location.longitude,
            //        latitude = location.latitude,
            //        bandwidth = 20,
            //        tier = new TierEntity() { id = 1}
            //    });
            //}

            //foreach (var node in nodes)
            //{
            //    var cable = CableGenerator.MakeCables(node, nodes);
            //    DBTool.Write(node);
            //}

            //var list = new List<CableEntity>();
            //list.Add(testCable);
            //CableGenerator.MakeCables(nodes)

        }// End Main



    }// End Class
}
