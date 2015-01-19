using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;

namespace GOTHAM.Model
{
  public class PersonEntityMap : ClassMap<PersonEntity>
  {

    public PersonEntityMap()
    {
      Table("person");
      Id(x => x.id).GeneratedBy.Identity();
      Map(x => x.name).Not.Nullable();


    }
  }
}
