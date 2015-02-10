using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // TODO: Change class and type\protocol to protected
    class Ethernet : Layer1, ILayer2
    {
        protected enum l3_type { IP, ICMP }
        protected l3_type l3 { get; set; }
        public MAC mac_dest { get; set; }
        public MAC mac_src { get; set; }


        protected Ethernet(MAC dest, MAC source)
        {
            l2 = l2_type.Ethernet;
            mac_dest = dest;
            mac_src = source;
        }
        protected Ethernet()
        {
            l2 = l2_type.Ethernet;
        }
    }
}
