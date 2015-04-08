using System.Collections.Generic;
using GOTHAM.Application.Tools;
using GOTHAM.Model;
// ReSharper disable UnusedAutoPropertyAccessor.Global

namespace GOTHAM.Traffic.Misc
{
    /// <summary>
    /// A session between two hosts containing path and packets exchanged.
    /// </summary>
    public class Session
    {
        public Dictionary<int, NodeEntity> Path { get; set; }
        public HostEntity SourceHost { get; set; }
        public HostEntity TargetHost { get; set; }
        public Stack<Packet> Packets { get; set; }

        /// <summary>
        /// Finds a path between source and target nodes and stores packages exchanged.
        /// </summary>
        /// <param name="sourceHost"></param>
        /// <param name="targetHost"></param>
        public Session(HostEntity sourceHost, HostEntity targetHost)
        {
            var startNode = sourceHost.Node;
            var endNode = targetHost.Node;
            Path = new Pathfinder().TryRandom(startNode, endNode, 10000).ToDictionary();
        }


    }
}
