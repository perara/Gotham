using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class HostEntity : BaseEntity
    {

        public virtual string machineName { get; set; }
        public virtual bool online { get; set; }
        public virtual PersonEntity owner { get; set; }
    }

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
