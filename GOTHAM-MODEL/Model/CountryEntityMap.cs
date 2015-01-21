using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;
using GOTHAM.Model;

namespace GOTHAM_MODEL.Model
{
  public class CountryEntityMap : ClassMap<CountryEntity>
  {

    public CountryEntityMap()
    {
      Table("country");
      Id(x => x.id).GeneratedBy.Identity();
      Map(x => x.name).Not.Nullable();
      Map(x => x.countryCode).Not.Nullable();
      Map(x => x.countryCodeExtended).Not.Nullable();
    }



  }

}
