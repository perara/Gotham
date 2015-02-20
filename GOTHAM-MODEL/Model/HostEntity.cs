using GOTHAM.Tools;
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

        // TODO: Use IP and MAC classes. (Exists in Tools project)
        public virtual string ip { get; set; }
        public virtual string mac { get; set; }
    }

    public class HostEntityMap : ClassMap<HostEntity>
    {
        public HostEntityMap()
        {
            Table("host");
            Id(x => x.id).GeneratedBy.Identity();
            Map(x => x.machineName);
            Map(x => x.online);
            Map(x => x.ip);
            Map(x => x.mac);
            References(x => x.owner);

        }
    }

}
