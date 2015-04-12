using System.Diagnostics.CodeAnalysis;
using FluentNHibernate.Mapping;

namespace GOTHAM.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
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

            Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
        }
    }
}