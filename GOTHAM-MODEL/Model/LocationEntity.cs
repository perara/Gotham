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
        public virtual string countrycode { get; set; }
        public virtual string name { get; set; }
        public virtual double lat { get; set; }
        public virtual double lng { get; set; }
    }

    public class LocationEntityMap : ClassMap<LocationEntity>
    {
        public LocationEntityMap()
        {
            Table("location");

            Id(x => x.id).GeneratedBy.Identity();
            Map(x => x.countrycode).Not.Nullable();
            Map(x => x.name).Not.Nullable();
            Map(x => x.lat).Not.Nullable();
            Map(x => x.lng).Not.Nullable();
            Map(x => x.Random).Formula("RAND()");
        }
    }
}
