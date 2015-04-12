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
    public class CableTypeEntity : BaseEntity
  {

    public virtual string Name { get; set; }

  }

    public class CableTypeEntityMap : ClassMap<CableTypeEntity>
    {

        public CableTypeEntityMap()
        {
            Table("cable_type");
            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.Name);

            Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
        }
    }
}
