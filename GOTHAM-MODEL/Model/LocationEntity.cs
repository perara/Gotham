using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class LocationEntity
    {
        public virtual int id { get; set; }
        public virtual string countrycode { get; set; }
        public virtual string name { get; set; }
        public virtual double latitude { get; set; }
        public virtual double longitude { get; set; }
    }
}
