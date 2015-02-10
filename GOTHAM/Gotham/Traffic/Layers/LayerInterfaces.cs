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

    interface ILayer2
    {
        MAC mac_dest { get; set; }
        MAC mac_src { get; set; }
    }

    interface ILayer3
    {

    }

    interface ILayer4
    {
        int srcPort { get; set; }
        int dstPort { get; set; }
        int length { get; set; }
    }

    interface ILayer6
    {

    }

    interface ILayer7
    {
        string data { get; set; }
    }
}
