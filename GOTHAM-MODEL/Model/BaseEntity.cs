using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace GOTHAM.Model
{
    public class BaseEntity
    {
        public virtual int id { get; set; }

        [JsonIgnore]
        public virtual string Random { get; set; }

        public virtual string ToJson()
        {
          return JsonConvert.SerializeObject(this);
        }
    }
}
