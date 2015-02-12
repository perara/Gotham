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
        public enum icmp_Type { echoReply = 0, unreachable = 3, echo = 8, timeout = 11, tracert = 30 }
        // Applies for code 3, unreachable
        public enum icmp_Code { Net_Unreachable, Host_Unreachable, Protocol_Unreachable, Port_Unreachable }

        public icmp_Type icmpType { get; set; }
        public icmp_Code icmpCode { get; set; }
        public string message { get; set; }

        protected ICMP()
        {
            l3 = l3_type.ICMP;
        }
    }

    // TODO: Change class and type\protocol to protected
    class IP : Ethernet, ILayer3
    {
        public enum l4_type { TCP, UDP }
        public l4_type l4 { get; protected set; }
        public int ipVersion { get; set; }
        public IP ipSrc { get; set; }
        public IP ipDest { get; set; }


        protected IP(IP src, IP dest, int version)
        {
            this.ipSrc = src;
            this.ipDest = dest;

           l3 = l3_type.IP;
        }
        protected IP()
        {
            l3 = l3_type.IP;
        }
    }
}

