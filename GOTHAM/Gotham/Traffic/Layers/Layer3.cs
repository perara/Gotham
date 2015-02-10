using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // Network Layer
    


    // TODO: Change class and type\protocol to protected
    class ICMP : Ethernet, ILayer3
    {
        protected enum icmp_Type { echoReply = 0, unreachable = 3, echo = 8, timeout = 11, tracert = 30 }
        // Applies for code 3, unreachable
        protected enum icmp_Code { Net_Unreachable, Host_Unreachable, Protocol_Unreachable, Port_Unreachable }

        protected icmp_Type icmpType { get; set; }
        protected icmp_Code icmpCode { get; set; }
        protected string message { get; set; }

        protected ICMP()
        {
            l3 = l3_type.ICMP;
        }
    }

    // TODO: Change class and type\protocol to protected
    class IP : Ethernet, ILayer3
    {
        protected enum l4_type { TCP, UDP }
        protected l4_type l4 { get; set; }
        protected int ipVersion { get; set; }
        protected IP src { get; set; }
        protected IP dest { get; set; }


        protected IP(IP src, IP dest, int version)
        {
            this.src = src;
            this.dest = dest;

           l3 = l3_type.IP;
        }
        protected IP()
        {
            l3 = l3_type.IP;
        }
    }
}

