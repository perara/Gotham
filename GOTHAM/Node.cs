using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM
{
    struct Node
    {
        public int id { get; set; }
        public int tier { get; set; }
        public int priority { get; set; }
        public double bandwidth { get; set; }
        public string provider { get; set; }

        List<Node> Neighbors { get; set; }
    }
}
