using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    // TODO: Change class and type\protocol to protected
    public class TCP : Layer4
    {
        public int portSrc { get; set; }
        public int portDest { get; set; }
        public int length { get; set; }


        public TCP()
        {
            type = l4_type.TCP;
        }
    }


    // TODO: Change class and type\protocol to protected
    public class UDP : Layer4
    {
        public int portSrc { get; set; }
        public int portDest { get; set; }
        public int length { get; set; }


        public UDP()
        {
            type = l4_type.UDP;
        }
    }
}
