using GOTHAM.Model;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    public class BaseLayer
    {
    }

    public class Layer2 : BaseLayer
    {
        public enum l2_type { Ethernet, Wifi }
        public l2_type type { get; protected set; }


        public HostEntity source { get; set; }
        public HostEntity dest { get; set; }

    }

    public class Layer3 : BaseLayer
    {
        public enum l3_type { ICMP, IP }
        public l3_type type { get; protected set; }

        public HostEntity source { get; set; }
        public HostEntity dest { get; set; }

    }

    public class Layer4 : BaseLayer
    {
        public enum l4_type { TCP, UDP }
        public l4_type type { get; protected set; }
        public string typeName { get; set; } // In case it is non-default port

        public int source { get; set; }
        public int dest { get; set; }
        public int length { get; set; }

    }

    public class Layer6 : BaseLayer
    {
        public enum l6_type { none, SSL, TLS, DTLS }
        public l6_type type { get; protected set; }

    }

    public class Layer7 : BaseLayer
    {
        public enum l7_type { HTTP, FTP, DNS, HTTPS, SFTP, SSH }
        public l7_type type { get; protected set; }

        public string hostApplication { get; set; }
        public DateTime date { get; set; }
        public HostEntity host { get; set; }
        public string data { get; set; }

    }
}
