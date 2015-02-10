using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    class BaseFrame
    {
        public enum l2_type { Ethernet, Wifi }
        public l2_type l2 { get; protected set; }
    }
}
