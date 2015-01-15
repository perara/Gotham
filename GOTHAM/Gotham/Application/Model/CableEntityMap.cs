using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Application.Model
{
    public class CableEntityMap : ClassMap<CableEntity>
    {

        public CableEntityMap()
        {
            Table("node_node");
            Id(x => x.id).GeneratedBy.Identity();
            Map(x => x.node1);
            Map(x => x.node2);
            Map(x => x.priority);
            // TODO map rest
            
        }

    }
}
