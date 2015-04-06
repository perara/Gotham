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
    public class UserEntity : BaseEntity
    {
        public virtual string Username { get; set; }
        public virtual string Password { get; set; }
        public virtual string Email { get; set; }
        public virtual string Money { get; set; }
        public virtual long Experience { get; set; }

        public virtual HostEntity HostEntity { get; set; }
    }

    public class UserEntityMap : ClassMap<UserEntity>
    {

        public UserEntityMap()
        {
            Table("user");
            Cache.ReadOnly();
            Id(x => x.Id).GeneratedBy.Identity();

            Map(x => x.Username);
            Map(x => x.Password);
            Map(x => x.Email);
            Map(x => x.Money);
            Map(x => x.Experience);
            HasOne(x => x.HostEntity).PropertyRef(x => x.Owner).Cascade.All(); 
        }



    }
}
