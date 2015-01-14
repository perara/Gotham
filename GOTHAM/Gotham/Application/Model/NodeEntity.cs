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

      // TODO Change to Location object... Point?
      public virtual int geoPosX { get; set; }
      public virtual int geoPosY { get; set; }
      /// <summary>
      /// neighbors node, This can only be a node within the same Tier level
      /// </summary>
      public virtual IList<NodeEntity> siblings { get; set; }

      public virtual String name { get; set; }
  }
}
