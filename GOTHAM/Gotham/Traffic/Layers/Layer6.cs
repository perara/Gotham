using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // Presentation Layer

    // TODO: Change class and type\protocol to protected
    class NoEncryption_TCP : TCP, ILayer6
    {
        public enum l7_type { HTTP, FTP, DNS }
        public l7_type l7 { get; protected set; }

        protected NoEncryption_TCP()
        {
            l6 = l6_type.none;
        }
    }

    class NoEncryption_UDP : UDP, ILayer6
    {
        public enum l7_type { HTTP, FTP, DNS }
        public l7_type l7 { get; protected set; }

        protected NoEncryption_UDP()
        {
            l6 = l6_type.none;
        }
    }


    // TODO: Change class and type\protocol to protected
    class SSL : TCP, ILayer6
    {
        public enum l7_type { HTTPS, SFTP, SSH }
        public l7_type l7 { get; protected set; }
        public Guid hash { get; set; }
        public int secVersion { get; set; }


        protected SSL(Guid hash, int version)
        {
            l6 = l6_type.SSL;

            this.hash = hash;
            this.secVersion = version;
        }
    }

    class TLS : TCP, ILayer6
    {
        public enum l7_type { HTTPS, SFTP, SSH }
        public l7_type l7 { get; protected set; }
        public Guid hash { get; set; }
        public int secVersion { get; set; }


        protected TLS(Guid hash, int version)
        {
            l6 = l6_type.TLS;

            this.hash = hash;
            this.secVersion = version;
        }
    }
}
