using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // Presentation Layer

    // TODO: Change class and type\protocol to protected
    class NoEncryption : TCP, ILayer6
    {
        protected enum l7_type { HTTP, FTP, DNS }
        protected l7_type l7 { get; set; }
        protected NoEncryption()
        {
            l6 = l6_type.none;
        }
    }


    // TODO: Change class and type\protocol to protected
    class SSL : TCP, ILayer6
    {
        protected enum l7_type { HTTPS, SFTP, SSH }
        protected l7_type l7 { get; set; }
        protected Guid hash { get; set; }
        protected int secVersion { get; set; }


        protected SSL(Guid hash, int version)
        {
            l6 = l6_type.SSL;

            this.hash = hash;
            this.secVersion = version;
        }
    }

    class TLS : TCP, ILayer6
    {
        protected enum l7_type { HTTPS, SFTP, SSH }
        protected l7_type l7 { get; set; }
        protected Guid hash { get; set; }
        protected int secVersion { get; set; }


        protected TLS(Guid hash, int version)
        {
            l6 = l6_type.TLS;

            this.hash = hash;
            this.secVersion = version;
        }
    }
}
