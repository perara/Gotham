using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // TODO: Change class and type\protocol to protected
    class Ethernet : BaseFrame, ILayer2
    {
        public enum l3_type { IP, ICMP }
        public l3_type l3 { get; protected set ; }
        public MAC macDest { get; set; }
        public MAC macSrc { get; set; }


        protected Ethernet(MAC dest, MAC source)
        {
            l2 = l2_type.Ethernet;
            macDest = dest;
            macSrc = source;
        }
        protected Ethernet()
        {
            l2 = l2_type.Ethernet;
        }
    }
}
