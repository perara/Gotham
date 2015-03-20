using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class LocationEntity : BaseEntity
    {
        public virtual string Countrycode { get; set; }
        public virtual string Name { get; set; }
        public virtual double Lat { get; set; }
        public virtual double Lng { get; set; }
    }

    public class LocationEntityMap : ClassMap<LocationEntity>
    {
        public LocationEntityMap()
        {
            Table("location");

            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.Countrycode).Not.Nullable();
            Map(x => x.Name).Not.Nullable();
            Map(x => x.Lat).Not.Nullable();
            Map(x => x.Lng).Not.Nullable();
            Map(x => x.Random).Formula("RAND()");
        }
    }
}
