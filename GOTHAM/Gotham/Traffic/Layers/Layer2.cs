using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    public class Ethernet : Layer2
    {
        public Ethernet(HostEntity dest, HostEntity source)
        {
            type = l2_type.Ethernet;
            this.source = source;
            this.dest = dest;
        }

        public Ethernet()
        {
            type = l2_type.Ethernet;
        }
    }

    public class WIFI : Layer2
    {
        public WIFI(HostEntity dest, HostEntity source)
        {
            type = l2_type.Ethernet;
            this.source = source;
            this.dest = dest;
        }

        public WIFI()
        {
            type = l2_type.Ethernet;
        }

    }
}
