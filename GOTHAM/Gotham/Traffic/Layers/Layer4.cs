using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    public class TCP : Layer4
    {
        //TODO: Sequence numbers for each packet
        public TCP()
        {
            type = l4_type.TCP;
        }
    }


    public class UDP : Layer4
    {
        public UDP()
        {
            type = l4_type.UDP;
        }
    }
}
