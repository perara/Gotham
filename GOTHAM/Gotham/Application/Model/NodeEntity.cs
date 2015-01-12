using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Application.Model
{
  public class NodeEntity
  {
      public virtual int id { get; set; }
      public virtual int tier { get; set; }
      public virtual int priority { get; set; }
      public virtual double bandwidth { get; set; }
     // public ProviderEntity provider { get; set; }

      ISet<NodeEntity> Neighbors { get; set; }

      public virtual String name { get; set; }
  }
}
