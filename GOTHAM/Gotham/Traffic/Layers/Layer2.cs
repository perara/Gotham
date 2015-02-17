using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // TODO: Change class and type\protocol to protected
    public class Ethernet : Layer2
    {
        public Ethernet(MAC dest, MAC source)
        {
            type = l2_type.Ethernet;
            macDest = dest;
            macSrc = source;
        }

        public Ethernet()
        {
            type = l2_type.Ethernet;
        }

    }

    public class WIFI : Layer2
    {
        public WIFI(MAC dest, MAC source)
        {
            type = l2_type.Ethernet;
            macDest = dest;
            macSrc = source;
        }

        public WIFI()
        {
            type = l2_type.Ethernet;
        }

    }
}
