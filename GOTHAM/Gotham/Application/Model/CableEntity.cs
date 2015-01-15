using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Application.Model
{
    public class CableEntity
    {

        // TODO: Coordinates for physical location of cable, not only linear
        public virtual int id { get; set; }
        public virtual NodeEntity node1 { get; set; }
        public virtual NodeEntity node2 { get; set; }
        public virtual int priority { get; set; }
        public virtual double bandwidth { get; set; }
        public virtual int type { get; set; }
        public virtual double quality { get; set; }
    }
}
