using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using FluentNHibernate.Mapping;
using Newtonsoft.Json;

namespace Gotham.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class DNSEntity : BaseEntity
    {

        public virtual string Ipv4 { get; set; }
        public virtual string Ipv6 { get; set; }
        public virtual string Address { get; set; }
        public virtual IPProviderEntity Provider { get; set; }

    }

    public class DNSEntityMap : ClassMap<DNSEntity>
    {
        public DNSEntityMap()
        {

            Table("dns");

            Id(x => x.Id, "id").GeneratedBy.Identity();

            Map(x => x.Ipv4);
            Map(x => x.Ipv6);
            Map(x => x.Address);

            References(x => x.Provider, "provider")
                .Nullable()
                .Not.LazyLoad();

        }



    }
}
