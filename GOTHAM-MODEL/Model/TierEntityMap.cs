using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;

namespace GOTHAM.Model
{
  public class TierEntityMap : ClassMap<TierEntity>
  {

    public TierEntityMap()
    {
      Table("tier");
      Id(x => x.id).GeneratedBy.Identity();
      Map(x => x.name);
    }



  }
}
