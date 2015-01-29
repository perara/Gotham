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
        public virtual NodeEntity node { get; set; }
        public virtual CableEntity cable { get; set; }

    }
    public class NodeCableEntityMap : ClassMap<NodeCableEntity>
    {
        public NodeCableEntityMap()
        {
            Table("node_cable");

            Id(x => x.id).GeneratedBy.Identity();

            References(x => x.cable).Not.Nullable().Column("cable");
            References(x => x.node).Not.Nullable().Column("node");

        }
    }
}