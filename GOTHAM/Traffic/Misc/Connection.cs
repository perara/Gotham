using System.Collections.Generic;
using GOTHAM.Model;
// ReSharper disable UnusedAutoPropertyAccessor.Global

namespace GOTHAM.Traffic.Misc
{
    /// <summary>
    /// A collection of all outbound sessions from a specific host.
    /// </summary>
    public class Connection
    {
        public List<Session> Sessions { get; set; }
        public HostEntity Host { get; set; }

        /// <summary>
        /// Generates a connection to be able to store sessions from specified host.
        /// </summary>
        /// <param name="host"></param>
        public Connection(HostEntity host)
        {
            Host = host;
        }
    }
}
