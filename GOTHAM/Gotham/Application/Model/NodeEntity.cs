using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;

namespace GOTHAM.Gotham.Application.Model
{
    public class NodeEntity
    {
        public virtual int id { get; set; }
        public virtual int tier { get; set; }
        public virtual int priority { get; set; }
        public virtual double bandwidth { get; set; }
        
        // TODO Change to location Point object
        public virtual int geoPosX { get; set; }
        public virtual int geoPosY { get; set; }

        public virtual ISet<NodeEntity> siblings { get; set; }
        public virtual string name { get; set; }

        public NodeEntity()
        {
            siblings = new ISet<NodeEntity>();
        }
    }
}
