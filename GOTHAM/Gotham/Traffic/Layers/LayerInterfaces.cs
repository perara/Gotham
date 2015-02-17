using GOTHAM.Model;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    class LayerInterfaces
    {
    }

    public class Layer2
    {
        public enum l2_type { Ethernet, Wifi }
        public l2_type type { get; protected set; }


        public MAC macDest { get; set; }
        public MAC macSrc { get; set; }


        public Ethernet Ethernet(){

            return (Ethernet)this;
        }
        public WIFI WIFI()
        {

            return (WIFI)this;
        }
    }

    public class Layer3
    {
        public enum l3_type { IP, ICMP }
        public l3_type type { get; protected set; }


        public IP IP()
        {
            return (IP)this;
        }
        public ICMP ICMP()
        {
            return (ICMP)this;
        }
    }

    public class Layer4
    {
        public enum l4_type { TCP, UDP }
        public l4_type type { get; protected set; }

        public int portSrc { get; set; }
        public int portDest { get; set; }
        public int length { get; set; }

        public TCP TCP()
        {
            return (TCP)this;
        }
        public UDP UDP()
        {
            return (UDP)this;
        }
    }

    public class Layer6
    {
        public enum l6_type { none, SSL, TLS, DTLS }
        public l6_type type { get; protected set; }


        public NoEncryption NoEncryption()
        {
            return (NoEncryption)this;
        }
        public SSL SSL()
        {
            return (SSL)this;
        }
        public TLS TLS()
        {
            return (TLS)this;
        }
        public DTLS DTLS()
        {
            return (DTLS)this;
        }
    }

    public class Layer7
    {
        public enum l7_type { HTTP, FTP, DNS, HTTPS, SFTP, SSH }
        public l7_type type { get; protected set; }

        public string webServer { get; set; }
        public DateTime date { get; set; }
        public HostEntity host { get; set; }
        public string data { get; set; }


        public HTTP HTTP()
        {
            return (HTTP)this;
        }
        public FTP FTP()
        {
            return (FTP)this;
        }
        public DNS DNS()
        {
            return (DNS)this;
        }
        public HTTPS HTTPS()
        {
            return (HTTPS)this;
        }
        public SFTP SFTP()
        {
            return (SFTP)this;
        }
        public SSH SSH()
        {
            return (SSH)this;
        }
    }
}
