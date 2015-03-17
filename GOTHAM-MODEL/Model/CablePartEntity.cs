using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace GOTHAM.Model
{
    public class CablePartEntity : BaseEntity
    {

        [JsonIgnore]
        public virtual CableEntity cable { get; set; }
        public virtual int number { get; set; }
        public virtual double lat { get; set; }
        public virtual double lng { get; set; }
        protected CablePartEntity() { }
        public CablePartEntity(CableEntity cable, int number, double lat, double lng)
        {
            this.cable = cable;
            this.number = number;
            this.lat = lat;
            this.lng = lng;
        }
    }

    public class CablePartEntityMap : ClassMap<CablePartEntity>
    {
        public CablePartEntityMap()
        {
            Table("cable_part");

            Id(x => x.id).GeneratedBy.Identity();

            Map(x => x.number);
            Map(x => x.lat);
            Map(x => x.lng);
    
            References(x => x.cable)
                .Not.Nullable()
                .Column("cable");

        }
    }
}
