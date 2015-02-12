using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // TODO: Change class and type\protocol to protected
    


    // TODO: Change class and type\protocol to protected
    class TCP : IP, ILayer4
    {
        public enum l6_type { none, SSL, TLS }
        public l6_type l6 { get; protected set; }
        public int portSrc { get; set; }
        public int portDest { get; set; }
        public int length { get; set; }


        protected TCP()
        {
            l4 = l4_type.TCP;
        }
    }


    // TODO: Change class and type\protocol to protected
    class UDP : IP, ILayer4
    {
        public enum l6_type { none, DTLS }
        public l6_type l6 { get; set; }
        public int portSrc { get; set; }
        public int portDest { get; set; }
        public int length { get; set; }


        protected UDP()
        {
            l4 = l4_type.UDP;
        }
    }
}
