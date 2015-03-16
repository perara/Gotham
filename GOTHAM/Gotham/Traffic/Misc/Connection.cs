using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    /// <summary>
    /// A collection of all outbound sessions from a specific host.
    /// </summary>
    public class Connection
    {
        public List<Session> sessions { get; set; }
        public HostEntity host { get; set; }

        /// <summary>
        /// Generates a connection to be able to store sessions from specified host.
        /// </summary>
        /// <param name="host"></param>
        public Connection(HostEntity host)
        {
            this.host = host;
        }
    }
}
