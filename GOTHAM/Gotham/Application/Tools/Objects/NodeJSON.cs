using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Application.Tools.Objects
{
    public class NodeJSON
    {
        public string country { get; set; }
        public string name { get; set; }
        public Coordinates coordinates { get; set; }

    }
    public class Coordinates
    {
        public string latitude { get; set; }
        public string longitude { get; set; }
    }
}
