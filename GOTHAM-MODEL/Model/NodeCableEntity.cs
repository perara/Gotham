using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class NodeCableEntity : BaseEntity
    {
        public virtual NodeEntity Node { get; set; }
        public virtual CableEntity Cable { get; set; }

    }
    public class NodeCableEntityMap : ClassMap<NodeCableEntity>
    {
        public NodeCableEntityMap()
        {
            Table("node_cable");

            Id(x => x.Id).GeneratedBy.Identity();

            References(x => x.Cable).Not.Nullable().Column("cable");
            References(x => x.Node).Not.Nullable().Column("node");

        }
    }
}