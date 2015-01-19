using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NHibernate.Mapping;

namespace GOTHAM.Model
{
  public class CableEntityMap : ClassMap<CableEntity>
  {

    public CableEntityMap()
    {
      Table("cable");
      Id(x => x.id).GeneratedBy.Identity();
      References(x => x.node1, "id").Column("node_1");
      References(x => x.node2, "id").Column("node_2");
      Map(x => x.priority);
      Map(x => x.bandwidth);
      Map(x => x.quality);
      References(x => x.type, "id"); 
      // TODO map rest

    }

  }
}
