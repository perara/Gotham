using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class CablePartEntity : BaseEntity
    {
        public virtual CableEntity cable { get; set; }
        public virtual int number { get; set; }
        public virtual double latitude{ get; set; }
        public virtual double longitude { get; set; }
        
    }

    public class CablePartEntityMap : ClassMap<CablePartEntity>
    {
        public CablePartEntityMap()
        {
            Table("cable_part");

            Id(x => x.id).GeneratedBy.Identity();

            Map(x => x.number);
            Map(x => x.latitude);
            Map(x => x.longitude);

            References(x => x.cable).Not.Nullable().Column("cable");

        }

    }
}
