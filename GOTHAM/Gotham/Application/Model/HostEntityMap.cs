using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;

namespace GOTHAM.Gotham.Application.Model
{
  public class HostEntityMap : ClassMap<HostEntity>
  {

    public HostEntityMap()
    {
      Table("host");
      Id(x => x.id).GeneratedBy.Identity();
      Map(x => x.machineName);
      Map(x => x.online);
      References(x => x.owner);

    }


  }
}
