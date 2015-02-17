using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // Network Layer
    // TODO: Change class and type\protocol to protected
    public class ICMP : Layer3
    {
        public enum icmp_Type { echoReply = 0, unreachable = 3, echo = 8, timeout = 11, tracert = 30 }
        // Applies for code 3, unreachable
        public enum icmp_Code { Net_Unreachable, Host_Unreachable, Protocol_Unreachable, Port_Unreachable }

        public icmp_Type icmpType { get; set; }
        public icmp_Code icmpCode { get; set; }
        public string message { get; set; }

        public ICMP()
        {
            type = l3_type.ICMP;
        }
    }

    // TODO: Change class and type\protocol to protected
    public class IP : Layer3
    {
        
        public int ipVersion { get; set; }
        public IP ipSrc { get; set; }
        public IP ipDest { get; set; }


        public IP(IP src, IP dest, int version)
        {
            this.ipSrc = src;
            this.ipDest = dest;

           type = l3_type.IP;
        }
        public IP()
        {
            type = l3_type.IP;
        }
    }
}

