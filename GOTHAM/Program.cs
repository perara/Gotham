﻿using System;
using System.Globalization;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading;
using GOTHAM.Application.Tools.Cache;
using GOTHAM.Model;
using GOTHAM.Repository;
using GOTHAM.Repository.Abstract;
using GOTHAM.Service.SignalR;
using GOTHAM.Service.WebAPI;
using GOTHAM.Tools;
using IronPython.Modules;

namespace GOTHAM
{
    static class Program
    {
        private static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        static void Main()
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
            CacheEngine.Init();
            Log.Info((DateTime.Now - time).Seconds + "." + (DateTime.Now - time).Milliseconds + " to initiate cache engine");

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
work.Dispose();*/


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
