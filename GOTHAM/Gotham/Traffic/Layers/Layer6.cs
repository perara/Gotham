using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    // Presentation Layer

    // TODO: Change class and type\protocol to protected
    public class NoEncryption : Layer6
    {
        public NoEncryption()
        {
            type = l6_type.none;
        }
    }

    // TODO: Change class and type\protocol to protected
    public class SSL : Layer6
    {
        public Guid hash { get; set; }
        public int secVersion { get; set; }


        public SSL(Guid hash, int version)
        {
            type = l6_type.SSL;

            this.hash = hash;
            this.secVersion = version;
        }
    }

    public class TLS : Layer6
    {
        public Guid hash { get; set; }
        public int secVersion { get; set; }


        public TLS(Guid hash, int version)
        {
            type = l6_type.TLS;

            this.hash = hash;
            this.secVersion = version;
        }
    }

    public class DTLS : Layer6
    {
        public Guid hash { get; set; }
        public int secVersion { get; set; }


        public DTLS(Guid hash, int version)
        {
            type = l6_type.DTLS;

            this.hash = hash;
            this.secVersion = version;
        }
    }
    
}
