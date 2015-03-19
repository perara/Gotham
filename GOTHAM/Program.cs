using System;
using System.Collections.Generic;
using System.Globalization;
using GOTHAM.Model;
using GOTHAM.Tools;
using GOTHAM.Gotham.Service.ServiceStack;
using GOTHAM.Gotham.Service.SignalR;
using GOTHAM.Traffic;
using GOTHAM.Tools.Cache;
using System.Threading;
using System.Linq;
using GOTHAM.Model.Tools;

namespace GOTHAM
{
    class Program
    {
        public static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);


        static void Main(string[] args)
        {
            /////////////////////////////////////////////////////////////////
            //
            // Initial Setup
            //
            /////////////////////////////////////////////////////////////////

            //
            // Configure Log4Net
            // 
            log4net.Config.XmlConfigurator.Configure();

            //
            // Start ServiceStack API Server
            //
            // TODO: Gir feilmelding ServiceStackConsoleHost.Start();

            //
            // Start SignalR
            //
            new Thread(() =>
            {
                Thread.CurrentThread.IsBackground = true;
                SignalR r = new SignalR();
                r.Start();
            }).Start();

            //
            // Init Cache Engine
            //
            DateTime time = DateTime.Now;
            CacheEngine.Init();
            log.Info((DateTime.Now - time).Seconds + "." + (DateTime.Now - time).Milliseconds + " to initiate cache engine");




            /////////////////////////////////////////////////////////////////
            //
            // Other stuff
            //
            /////////////////////////////////////////////////////////////////


            // Change decimal seperator to . instead of ,
            System.Globalization.CultureInfo customCulture = (System.Globalization.CultureInfo)System.Threading.Thread.CurrentThread.CurrentCulture.Clone();
            customCulture.NumberFormat.NumberDecimalSeparator = ".";
            CultureInfo.DefaultThreadCurrentCulture = customCulture;

            // ========================================================================================
            // ===========================        TEST CODE       =====================================


            /*
            var countries = Globals.GetInstance().getTable<CountryEntity>();
            var nodeEstimate = NodeGenerator.estimateNodes(countries);
            var newLocations = NodeGenerator.generateFromEstimate(nodeEstimate);
            List<BaseEntity> newNodes = new List<BaseEntity>();
            newNodes.AddRange(NodeGenerator.convertLocToNode(newLocations));

            DBTool.WriteList(newNodes);
            
           
            
            NodeEntity start = new NodeEntity();
            NodeEntity end = new NodeEntity();
             */

            //NodeGenerator.fixNodeCountries();



            var nodes = CacheEngine.Nodes;
            //var node1 = nodes.Where(x => x.id == 16118).FirstOrDefault().GetCoordinates();
            //var node2 = nodes.Where(x => x.id == 15866).FirstOrDefault().GetCoordinates();

            //log.Info(GeoTool.GetDistance(node1, node2));


            CableGenerator.ConnectNodes(50);
            CableGenerator.ConnectSeaNodesToLand();
            CableGenerator.GenerateCables(nodes, 2, 3);
            

            //var path = new Pathfinder().TryRandom(start, end, 100000).toDictionary();

            //foreach (var item in path)
            //{
            //    log.Info(item.Value.name);
            //}

            //CableGenerator.ConnectSeaNodesToLand();

            //NodeGenerator.fixSeaNodes();


            //DBTool.WriteList(new List<string>());
            //CableGenerator.ConnectCloseNodes(nodes, 500);

            /*
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {
                    for (int i = 0; i < newCables.Count; i++)
                    {
                        session.Save(newCables[i]);
                        if (i % batchSize == 0)
                        {
                            session.Flush();
                            session.Clear();
                        }

                        // Prints persentage output each 100 entity
                        if (i % 100 == 0)
                        {
                            double p = 100.0 / newCables.Count * i;
                            log.Info((int)p + "%");
                        }
                    }
                    transaction.Commit();
                }// End transaction
            }// End session
            */

            //log.Info(newLocations.Count);


            //TxtParse.FromFile5("C:\\temp\\countries.txt");

            //var oldNodes = CacheEngine.Nodes;
            //var locations = Globals.GetInstance().getTable<LocationEntity>();
            //var nodes = NodeGenerator.convertLocToNode(locations);

            //foreach (var node in nodes)
            //{

            //var node = new NodeEntity();
            //node.name = "test";
            //node.lat = node.lng = 0;
            //node.tier = new TierEntity() { id = 2 };

            //DBTool.Write(node);

            //}


            /*

              var rawNodes = CacheEngine.Nodes;
              var nodesDict = new Dictionary<int, NodeEntity>();
              var nodesList = new List<NodeEntity>();

              foreach (var node in rawNodes)
              {
                node.getSiblings();
                nodesDict.Add(node.id, node);
                nodesList.Add(node);
              }

              Globals.GetInstance().log.Info("Finished loading from DB");
              Console.WriteLine("====================================================================");


              var node1 = nodesDict[3316];
              var node2 = nodesDict[3482];
              var testlist = new List<NodeEntity>();

              var path = new Pathfinder().TryRandom(node1, node2, nodesList, 100000);

              foreach (var node in path.toNodeList())
              {
                var numspaces = 35 - node.country.Length;
                var separator = "";
                for (int i = 0; i < numspaces; i++) separator += " ";
                Globals.GetInstance().log.Info(node.country + separator + node.name);
              }


              Console.WriteLine("====================================================================");

              Packet packet = new Packet(path).HTTP();
              packet.PrintLayers();
              var result = packet.IntegrityCheck() ? "success" : "fail";
              log.Info(result);

              packet.PrintJson();


              log.Info(rawNodes[0].ToJson());
                */


            // ========================================================================================
            // ========================================================================================

            log.Info("DOG FINISH");
            Console.ReadLine();


        }// End Main
    }// End Class
}
