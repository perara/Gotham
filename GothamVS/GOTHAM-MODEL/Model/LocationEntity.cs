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
    public class LocationEntity : BaseEntity
    {
        public virtual string Countrycode { get; set; }
        public virtual string Name { get; set; }
        public virtual double Lat { get; set; }
        public virtual double Lng { get; set; }
    }

    public class LocationEntityMap : ClassMap<LocationEntity>
    {
        public LocationEntityMap()
        {
            Cache.ReadWrite().Region("Entities");
            Table("location");

            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.Countrycode).Not.Nullable();
            Map(x => x.Name).Not.Nullable();
            Map(x => x.Lat).Not.Nullable();
            Map(x => x.Lng).Not.Nullable();
            Map(x => x.Random).Formula("RAND()");

            Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
        }
    }
}
