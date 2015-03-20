using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class TierEntity : BaseEntity
    {
        public virtual string Name { get; set; }

    }

    public class TierEntityMap : ClassMap<TierEntity>
    {

        public TierEntityMap()
        {
            Table("tier");
            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.Name).ReadOnly();
        }



    }
}
