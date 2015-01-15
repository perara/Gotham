using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IronPython.Modules;
using NHibernate.Mapping;

namespace GOTHAM.Gotham.Application.Model
{
  public class CableEntityMap : ClassMap<CableEntity>
  {

    public CableEntityMap()
    {
      Table("cable");
      Id(x => x.id).GeneratedBy.Identity();
      Map(x => x.priority);
      Map(x => x.bandwidth);
      Map(x => x.quality);
      References(x => x.type);
      // TODO map rest

    }

  }
}
