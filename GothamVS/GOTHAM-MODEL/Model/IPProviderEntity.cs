using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using FluentNHibernate.Mapping;
using Gotham.Tools;
using Newtonsoft.Json;
using NHibernate.Mapping;


namespace Gotham.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class IPProviderEntity : BaseEntity
    {
        public virtual int Id { get; set; }
        public virtual string From { get; set; }
        public virtual string To { get; set; }
        public virtual DateTime AssignDate { get; set; }
        public virtual CountryEntity Country { get; set; }
        public virtual string CountryId { get; set; }
        public virtual string Owner { get; set; }

    }

    public class IpProviderEntityMap : ClassMap<IPProviderEntity>
    {

        public IpProviderEntityMap()
        {

            Table("country_ip");

            Id(x => x.Id).Column("id").GeneratedBy.Identity();
            Map(x => x.From, "from_ip").Not.Nullable();
            Map(x => x.To, "to_ip").Not.Nullable();
            Map(x => x.AssignDate, "assign_date").Not.Nullable();
            Map(x => x.Owner, "owner").Not.Nullable();
            Map(x => x.CountryId, "country").Not.Nullable();

            References(x => x.Country)
                .Column("country")
                .PropertyRef("CountryCode")
                .Not.Nullable()
                .Not.LazyLoad();


        }

    }
}
