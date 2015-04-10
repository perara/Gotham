using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using GOTHAM.Application.Tools;
using GOTHAM.Traffic.Layers;
using Newtonsoft.Json;

namespace GOTHAM.Traffic.Misc
{
    /// <summary>
    /// A single packet built on the OSI model containing relevant headers for each protocol and data
    /// </summary>
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    public class Packet //<L2, L3, L4, L6, L7>
    {
        /// <summary>
        /// Loads the logger from the global singleton class
        /// </summary>
        readonly log4net.ILog _log = Globals.GetInstance().Log;

        /// <summary>
        /// Is this package consistent (realistic)
        /// </summary>
        public bool Consistent { get; set; }

        /// <summary>
        /// Stack of nodes in order for the path the package should take. First node is sender, last node is reciever
        /// </summary>
        public Pathfinder Path { get; set; }
        public Stack<int> PathId { get; set; }
        public int Id { get; set; }



        public Packet(Pathfinder path)
        {
            Consistent = false;
            PathId = path.ToIdList();
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
            Link = link;
            Network = network;
            Transport = transport;
            Encryption = encryption;
            Application = application;
        }

        /// <summary>
        /// Generates a new ICMP packet and checks packet integrity
        /// </summary>
        /// <returns></returns>
        public Packet Icmp()
        {
            Build(new Ethernet(), new Icmp());
            return IntegrityCheck() ? this : null;
        }

        /// <summary>
        /// Generates a new HTTP packet and checks packet integrity
        /// </summary>
        /// <returns></returns>
        public Packet Http()
        {
            Build(new Ethernet(), new Ip(), new Tcp(), new NoEncryption(), new Http());
            return IntegrityCheck() ? this : null;
        }

        /// <summary>
        /// Check the package structure integrity
        /// </summary>
        /// <returns></returns>
        public bool IntegrityCheck()
        {
            var layers = new List<BaseLayer>() { Link, Network, Transport, Encryption, Application };
            var layerEnd = false;

            foreach (var layer in layers)
            {
                if (layer != null && layerEnd)
                {
                    _log.Error("Integrity check failed");
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
            Consistent = IntegrityCheck();
            return JsonConvert.SerializeObject(this);
        }

        /// <summary>
        /// Print this packet to console
        /// </summary>
        public void PrintJson()
        {
            var json = JsonConvert.SerializeObject(this, Formatting.Indented);
            _log.Info(json);
        }

        /// <summary>
        /// Prints info about packet in log
        /// </summary>
        public void PrintLayers()
        {
            _log.Info("=========================================");

            _log.Info("Link Layer: \t\t" + Link.GetType().Name);
            _log.Info("Network Layer: \t" + Network.GetType().Name);
            _log.Info("Transport Layer: \t" + Transport.GetType().Name);
            _log.Info("Encryption Layer: \t" + Encryption.GetType().Name);
            _log.Info("Application Layer: \t" + Application.GetType().Name);

            _log.Info("=========================================");
        }
    }
}
