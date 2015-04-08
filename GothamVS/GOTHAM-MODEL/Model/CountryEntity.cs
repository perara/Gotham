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
  public class CountryEntity : BaseEntity
  {
    public virtual string Name { get; set; }
    public virtual string CountryCode { get; set; }
    public virtual string CountryCodeExt { get; set; }
    public virtual double Size { get; set; }
    public virtual int Population { get; set; }
    public virtual string Continent { get; set; }
    public virtual int Nodes { get; set; }
  }

  public class CountryEntityMap : ClassMap<CountryEntity>
  {

      public CountryEntityMap()
      {
          Cache.ReadWrite().Region("Entities");
          Table("country");
          Id(x => x.Id).GeneratedBy.Identity();
          Map(x => x.Name).Not.Nullable();
          Map(x => x.CountryCode).Not.Nullable();
          Map(x => x.CountryCodeExt).Not.Nullable();
          Map(x => x.Size).Not.Nullable();
          Map(x => x.Population).Not.Nullable();
          Map(x => x.Continent).Not.Nullable();

          Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
      }
  }
}
