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
    public class TierEntity
    {
        public virtual int Id { get; set; }
        public virtual string Name { get; set; }
    }

    public class TierEntityMap : ClassMap<TierEntity>
    {

        public TierEntityMap()
        {
            Table("tier");
            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.Name).ReadOnly();

            Cache.NonStrictReadWrite().IncludeAll().Region("LongTerm");
        }



    }
}
