using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    public class Session
    {
        public Dictionary<int, NodeEntity> path { get; set; }
        public HostEntity sourceHost { get; set; }
        public HostEntity targetHost { get; set; }
        public Stack<Packet> packets { get; set; }

        public Session()
        {
            //var soureHost = path[0].getHost();
            //var targetHost = path[-1].getHost();
        }
    }
}
