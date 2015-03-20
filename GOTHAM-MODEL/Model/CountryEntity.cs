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
    public virtual int Id { get; set; }
    public virtual string Name { get; set; }
    public virtual string CountryCode { get; set; }
    public virtual string CountryCodeExt { get; set; }
    public virtual double Size { get; set; }
    public virtual int Population { get; set; }
    public virtual string Continent { get; set; }
    public virtual int Nodes { get; set; }
  }

  public class CountryEntityMap : ClassMap<CountryEntity>
  {

      public CountryEntityMap()
      {
          Table("country");
          Id(x => x.Id).GeneratedBy.Identity();
          Map(x => x.Name).Not.Nullable();
          Map(x => x.CountryCode).Not.Nullable();
          Map(x => x.CountryCodeExt).Not.Nullable();
          Map(x => x.Size).Not.Nullable();
          Map(x => x.Population).Not.Nullable();
          Map(x => x.Continent).Not.Nullable();
      }
  }
}
