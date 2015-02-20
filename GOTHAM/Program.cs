using System;
using System.Collections.Generic;
using System.Globalization;

using GOTHAM.Model;
using GOTHAM.Tools;
using GOTHAM.API;
using GOTHAM.Traffic;
using Newtonsoft.Json;
using Microsoft.AspNet.SignalR;
using SignalRChat;

namespace GOTHAM
{
    class Program
    {
        static log4net.ILog log = Globals.GetInstance().log;
        

        static void Main(string[] args)
        {

            var sessions = new List<Stack<NodeEntity>>();

            // ServiceStack API Server
            ServiceStackConsoleHost.Start();

            //Initiate logging class
            log4net.Config.XmlConfigurator.Configure();

            // Change decimal seperator to . instead of ,
            System.Globalization.CultureInfo customCulture = (System.Globalization.CultureInfo)System.Threading.Thread.CurrentThread.CurrentCulture.Clone();
            customCulture.NumberFormat.NumberDecimalSeparator = ".";
            CultureInfo.DefaultThreadCurrentCulture = customCulture;

            // ========================================================================================
            // ===========================        TEST CODE       =====================================

            var rawNodes = Globals.GetInstance().nodes;
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

            var test = new MakeCon();
            
            
            

            // ========================================================================================
            // ========================================================================================

            Globals.GetInstance().log.Info("DOG FINISH");
            Console.ReadLine();


        }// End Main
    }// End Class
}
