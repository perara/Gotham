using GOTHAM.Tools;
using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceStack.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace GOTHAM.Traffic
{
    /// <summary>
    /// A single packet built on the OSI model containing relevant headers for each protocol and data
    /// </summary>
    public class Packet //<L2, L3, L4, L6, L7>
    {
        /// <summary>
        /// Loads the logger from the global singleton class
        /// </summary>
        log4net.ILog log = Globals.GetInstance().Log;

        /// <summary>
        /// Is this package consistent (realistic)
        /// </summary>
        public bool consistent { get; set; }

        /// <summary>
        /// Stack of nodes in order for the path the package should take. First node is sender, last node is reciever
        /// </summary>
        public Pathfinder path { get; set; }
        public Stack<int> pathId { get; set; }
        public int id { get; set; }
        public Layer2 link { get; set; }
        public Layer3 network { get; set; }
        public Layer4 transport { get; set; }
        public Layer6 encryption { get; set; }
        public Layer7 application { get; set; }


        public Packet(Pathfinder path)
        {
            consistent = false;
            pathId = path.ToIdList();
            //network.source = path.solution.First().Value.host;
            //network.dest = path.solution.Last().Value.host;
        }

        /// <summary>
        /// Builds a packet from defined types and protocols. Layer2 default is Ethernet
        /// </summary>
        /// <param name="link">Ethernet, WIFI</param>
        /// <param name="network">IP, ICMP</param>
        /// <param name="transport">TCP, UDP</param>
        /// <param name="encryption">NoEncryption, TLS, SSL</param>
        /// <param name="application">HTTP, HTTPS, FTP, SSH</param>
        public void Build(
            Layer2 link = null,
            Layer3 network = null,
            Layer4 transport = null,
            Layer6 encryption = null,
            Layer7 application = null)
        {
            this.link = link;
            this.network = network;
            this.transport = transport;
            this.encryption = encryption;
            this.application = application;
        }

        /// <summary>
        /// Generates a new ICMP packet and checks packet integrity
        /// </summary>
        /// <returns></returns>
        public Packet ICMP()
        {
            Build(new Ethernet(), new ICMP());
            return IntegrityCheck() ? this : null;
        }

        /// <summary>
        /// Generates a new HTTP packet and checks packet integrity
        /// </summary>
        /// <returns></returns>
        public Packet HTTP()
        {
            Build(new Ethernet(), new IP(), new TCP(), new NoEncryption(), new HTTP());
            return IntegrityCheck() ? this : null;
        }

        /// <summary>
        /// Check the package structure integrity
        /// </summary>
        /// <returns></returns>
        public bool IntegrityCheck()
        {
            var layers = new List<BaseLayer>() { link, network, transport, encryption, application };
            var layerEnd = false;

            foreach (var layer in layers)
            {
                if (layer != null && layerEnd)
                {
                    log.Error("Integrity check failed");
                    return false;
                }

                else if (layer == null)
                    layerEnd = true;
            }
            return true;
        }

        /// <summary>
        /// Converts this package to JSON string
        /// </summary>
        /// <returns></returns>
        public string ToJson()
        {
            consistent = IntegrityCheck();
            return JsonConvert.SerializeObject(this);
        }

        /// <summary>
        /// Print this packet to console
        /// </summary>
        public void PrintJson()
        {
            var json = JsonConvert.SerializeObject(this, Formatting.Indented);
            log.Info(json);
        }

        /// <summary>
        /// Prints info about packet in log
        /// </summary>
        public void PrintLayers()
        {

            log.Info("=========================================");

            log.Info("Link Layer: \t\t" + link.GetType().Name);
            log.Info("Network Layer: \t" + network.GetType().Name);
            log.Info("Transport Layer: \t" + transport.GetType().Name);
            log.Info("Encryption Layer: \t" + encryption.GetType().Name);
            log.Info("Application Layer: \t" + application.GetType().Name);

            log.Info("=========================================");
        }
    }
}
