using GOTHAM.Model;

namespace GOTHAM.Traffic.Layers
{
    public class Icmp : Layer3
    {
        public enum IcmpTypes { EchoReply = 0, Unreachable = 3, Echo = 8, Timeout = 11, Tracert = 30 }
        // Applies for code 3, unreachable
        public enum IcmpCodes { NetUnreachable, HostUnreachable, ProtocolUnreachable, PortUnreachable }

        public IcmpTypes IcmpType { get; set; }
        public IcmpCodes IcmpCode { get; set; }
        public string Message { get; set; }

        public Icmp()
        {
            Type = L3Type.Icmp;
        }
    }

    public class Ip : Layer3
    {
        
        public int IpVersion { get; set; }

        public Ip(HostEntity src, HostEntity dest)
        {
            Source = src;
            Dest = dest;

           Type = L3Type.Ip;
        }
        public Ip()
        {
            Type = L3Type.Ip;
        }
    }
}

