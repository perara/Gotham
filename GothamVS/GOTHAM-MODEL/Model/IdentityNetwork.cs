using System.Diagnostics.CodeAnalysis;
using FluentNHibernate.Mapping;

namespace Gotham.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class IdentityNetworkEntity : BaseEntity
    {
        public virtual NodeEntity Node { get; set; }
        public virtual IdentityEntity Identity { get; set; }
        public virtual NetworkEntity Network { get; set; }

    }
    public class IdentityNetworkEntityMap : ClassMap<IdentityNetworkEntity>
    {
        public IdentityNetworkEntityMap()
        {
            Table("identity");

            Id(x => x.Id).GeneratedBy.Identity();

            References(x => x.Identity).Not.Nullable().Column("identity");
            References(x => x.Network).Not.Nullable().Column("network");
            References(x => x.Node).Not.Nullable().Column("node");

            Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
        }
    }
}