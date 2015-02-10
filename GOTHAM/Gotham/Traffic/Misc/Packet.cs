using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    public class Packet
    {
        List<NodeEntity> path { get; set; }


        protected Packet(List<NodeEntity> path)
        {

        }
        protected Packet()
        {

        }
    }
}
