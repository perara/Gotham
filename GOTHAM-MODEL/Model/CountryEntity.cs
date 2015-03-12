using FluentNHibernate.Mapping;
using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
  public class CountryEntity : BaseEntity
  {

    public virtual int id { get; set; }
    public virtual string name { get; set; }
    public virtual string countryCode { get; set; }
    public virtual string countryCodeExt { get; set; }
    public virtual double size { get; set; }
    public virtual int population { get; set; }
    public virtual string continent { get; set; }
    public virtual int nodes { get; set; }

  }

  public class CountryEntityMap : ClassMap<CountryEntity>
  {

      public CountryEntityMap()
      {
          Table("country");
          Id(x => x.id).GeneratedBy.Identity();
          Map(x => x.name).Not.Nullable();
          Map(x => x.countryCode).Not.Nullable();
          Map(x => x.countryCodeExt).Not.Nullable();
          Map(x => x.size).Not.Nullable();
          Map(x => x.population).Not.Nullable();
          Map(x => x.continent).Not.Nullable();
      }
  }
}
