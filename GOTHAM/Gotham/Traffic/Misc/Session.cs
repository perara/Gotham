using GOTHAM.Model;
using GOTHAM.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    /// <summary>
    /// A session between two hosts containing path and packets exchanged.
    /// </summary>
    public class Session
    {
        public Dictionary<int, NodeEntity> path { get; set; }
        public HostEntity sourceHost { get; set; }
        public HostEntity targetHost { get; set; }
        public Stack<Packet> packets { get; set; }

        
        /// <summary>
        /// Finds a path between source and target nodes and stores packages exchanged.
        /// </summary>
        /// <param name="sourceHost"></param>
        /// <param name="targetHost"></param>
        public Session(HostEntity sourceHost, HostEntity targetHost)
        {
            var startNode = sourceHost.Node;
            var endNode = targetHost.Node;
            path = new Pathfinder().TryRandom(startNode, endNode, 10000).ToDictionary();
        }


    }
}
