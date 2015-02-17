using System;
using GOTHAM.Gotham.Application.Tools;
using GOTHAM.Model;
using GOTHAM.Model.Tools;
using GOTHAM.Gotham.API;
using System.Collections.Generic;
using GOTHAM.Tools;
using System.Globalization;
using GOTHAM_TOOLS;
using GOTHAM.Gotham.Traffic;

namespace GOTHAM
{
    class Program
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);


        static void Main(string[] args)
        {

            //Gotham.Traffic.Test.FTP ft = new Gotham.Traffic.Test.FTP();

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




           
            
            


            //var newNodes = TxtParse.FromFile2("C:\\temp\\tier2_missing_CountryCode.txt");
            //foreach (var node in newNodes)
            //{
            //    DBTool.Write(node);
            //}

            

            //var path2 = Pathfinder.ByDistance(node1, node2, nodesList);

            //foreach (var node in path2)
            //{
            //    log.Info(node.country + ": \t\t" + node.name);
            //}

            //var nodes = new List<NodeEntity>();
            //TxtParse.FromFile4("C:\\temp\\SeaCableCables.txt");

            //TxtParse.LocsToFile(locations, "C:\\temp\\SeaCableCablesTestOutput.txt");

            var rawNodes = Globals.GetInstance().getTable<NodeEntity>();
            var nodesDict = new Dictionary<int, NodeEntity>();
            var nodesList = new List<NodeEntity>();

            foreach (var node in rawNodes)
            {

                node.getSiblings();
                nodesDict.Add(node.id, node);
                nodesList.Add(node);
            }
            log.Info("Finished loading from DB");
            Console.WriteLine("====================================================================");

            //CableGenerator.ConnectCloseNodes(nodesList, 50);
            //CableGenerator.ConnectNodes(1);



            var node1 = nodesDict[3316];
            var node2 = nodesDict[3482];
            var testlist = new List<NodeEntity>();

            var path = Pathfinder.TryRandom(node1, node2, nodesList, 100000);

            foreach (var node in path)
            {
                var numspaces = 35 - node.country.Length;
                var separator = "";
                for (int i = 0; i < numspaces; i++) separator += " ";
                log.Info(node.country + separator + node.name);

            }


            Console.WriteLine("====================================================================");

            /*var path2 = Pathfinder.ByDistance(node1, node2, nodesList);

            foreach (var node in path2)
            {
                log.Info(node.country + ": \t\t" + node.name);
            }
            */

            Packet packet = new Packet(path);
            
            //CableGenerator.ConnectNodes(1);

            // ========================================================================================
            // ========================================================================================

            log.Info("DOG FINISH");
            Console.ReadLine();


        }// End Main



    }// End Class
}
