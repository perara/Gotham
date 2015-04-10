using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Threading;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using GOTHAM.Service.SignalR;
using GOTHAM.Service.WebAPI;
using NHibernate;
using NHibernate.Util;
using GOTHAM.Tools;
using NHibernate.Linq;


namespace GOTHAM
{
    static class Program
    {
        private static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        static void Main()
        {

 

            {
            // Create General Repository for UserEntity
           
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                 var start = DateTime.Now;
                session.Query<CableEntity>();
                var end = DateTime.Now - start;
                Console.WriteLine(end.TotalMilliseconds);
            }



            Console.ReadKey();

            }

      
            /*// Create Unit of work session
        var work = new UnitOfWork();

        // Create General Repository for UserEntity
        var userRepo = work.GetRepository<NodeEntity>();

        // Finn per
        DateTime startTime = DateTime.Now;
        var test = userRepo.All().ToList();
        foreach (var i in test)
        {
            Console.WriteLine(i.Id);
        }
        Console.WriteLine(userRepo.All());
        Console.WriteLine(DateTime.Now - startTime);
        startTime = DateTime.Now;
        Console.WriteLine(userRepo.All());
        Console.WriteLine(DateTime.Now - startTime);

        // Dispose session
        work.Dispose();

        // Create Unit of work session
        work = new UnitOfWork();
        userRepo = work.GetRepository<NodeEntity>();
        startTime = DateTime.Now;
        Console.WriteLine(userRepo.All());
        Console.WriteLine(DateTime.Now - startTime);
        work.Dispose();*/



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
            // (Kjør VS/App som ADMIN)
            //
            new Thread(() =>
            {
                Thread.CurrentThread.IsBackground = true;
                WebApi webApi = new WebApi();

            }).Start();


            //
            // Start SignalR
            //
            new Thread(() =>
            {
                Thread.CurrentThread.IsBackground = true;
                SignalR.Start();
            }).Start();

            //
            // Init Cache Engine
            //
            DateTime time = DateTime.Now;

            var ns = typeof(BaseEntity).Namespace;
            var types = typeof(BaseEntity).Assembly.GetExportedTypes()
                .Where(t => t.Namespace == ns)
                .Where(t => t.BaseType == typeof(BaseEntity));

            var cacheWork = new UnitOfWork();
            DateTime lastStep = time;
            types.ForEach(x =>
            {
                var step = DateTime.Now;

                if (x != typeof(BaseEntity) && x != typeof(LocationEntity) && x != typeof(PersonEntity))
                {
                    Log.InfoFormat("[{0}ms] Cached {1}...", (DateTime.Now - time).TotalMilliseconds, x.Name);
                    MethodInfo repoMethod = typeof(UnitOfWork).GetMethod("GetRepository");
                    MethodInfo generic = repoMethod.MakeGenericMethod(x);
                    var repository = generic.Invoke(cacheWork, null);
                    MethodInfo getAllMethod = repository.GetType().GetMethod("AllToList");
                    var query = getAllMethod.Invoke(repository, null);

                    lastStep = step;
                }




            });
            cacheWork.Dispose();
            Log.Info((DateTime.Now - time).Seconds + "." + (DateTime.Now - time).Milliseconds + " to init cache");

            /////////////////////////////////////////////////////////////////
            //
            // Other stuff
            //
            /////////////////////////////////////////////////////////////////


            // Change decimal seperator to . instead of ,
            var customCulture = (CultureInfo)Thread.CurrentThread.CurrentCulture.Clone();
            customCulture.NumberFormat.NumberDecimalSeparator = ".";
            CultureInfo.DefaultThreadCurrentCulture = customCulture;


            // ========================================================================================
            // ===========================        TEST CODE       =====================================


            /*// Create Unit of work session
var work = new UnitOfWork();

// Create General Repository for UserEntity
var userRepo = work.GetRepository<UserEntity>();

// Henta alle
Console.WriteLine(userRepo.All().ToList());
            
// Finn per
Console.WriteLine(userRepo.FindBy(x => x.Username == "per"));

// Dispose session
work.Dispose();

            using (var file = new System.IO.StreamWriter(@"C:\temp\nodesCables.txt"))
            {
                file.Write(CacheEngine.JsonNodesAndCables);
            }
*/
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



            //CableGenerator.ConnectNodesToCables();
            //var node1 = nodes.Where(x => x.id == 16118).FirstOrDefault().GetCoordinates();
            //var node2 = nodes.Where(x => x.id == 15866).FirstOrDefault().GetCoordinates();

            //log.Info(GeoTool.GetDistance(node1, node2));

            // Connect nodes to cables
            //CableGenerator.ConnectNodes(50);

            // Connect Sea nodes to land nodes
            //CableGenerator.ConnectSeaNodesToLand(1000);

            // Generate cables between land nodes
            //CableGenerator.GenerateCables(nodes, 2, 2, 1700);


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

            Log.Info("DOG FINISH");
            Console.ReadLine();


        }// End Main
    }// End Class
}
