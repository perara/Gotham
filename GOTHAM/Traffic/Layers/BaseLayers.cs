using System;
using GOTHAM.Model;
// ReSharper disable UnusedAutoPropertyAccessor.Global

namespace GOTHAM.Traffic.Layers
{
    public class BaseLayer
    {
    }

    public class Layer2 : BaseLayer
    {
        public enum L2Type { Ethernet, Wifi }
        public L2Type Type { get; protected set; }


        public HostEntity Source { get; set; }
        public HostEntity Dest { get; set; }

    }

    
    public class Layer3 : BaseLayer
    {
        public enum L3Type { Icmp, Ip }
        public L3Type Type { get; protected set; }

        public HostEntity Source { get; set; }
        public HostEntity Dest { get; set; }

    }

    public class Layer4 : BaseLayer
    {
        public enum L4Type { Tcp, Udp }
        public L4Type Type { get; protected set; }
        public string TypeName { get; set; } // In case it is non-default port

        public int Source { get; set; }
        public int Dest { get; set; }
        public int Length { get; set; }

    }

    public class Layer6 : BaseLayer
    {
        public enum L6Type { None, Ssl, Tls, Dtls }
        public L6Type Type { get; protected set; }

    }

    public class Layer7 : BaseLayer
    {
        public enum L7Type { Http, Ftp, Dns, Https, Sftp, Ssh }
        public L7Type Type { get; protected set; }

        public string HostApplication { get; set; }
        public DateTime Date { get; set; }
        public HostEntity Host { get; set; }
        public string Data { get; set; }

    }
}
