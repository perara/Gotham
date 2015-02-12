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
        MAC macDest { get; set; }
        MAC macSrc { get; set; }
    }

    interface ILayer3
    {

    }

    interface ILayer4
    {
        int portSrc { get; set; }
        int portDest { get; set; }
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
