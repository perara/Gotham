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
    public class NetworkEntity : BaseEntity
    {
        public virtual int Id { get; set; }
        public virtual string Submask { get; set; }
        public virtual string ExternalIPv4 { get; set; }
        public virtual string InternalIPv4 { get; set; }
        public virtual string MAC { get; set; }
        public virtual string DNS { get; set; }
        public virtual Boolean IsLocal { get; set; }
        public virtual Double Lat { get; set; }
        public virtual Double Lng { get; set; }
    }

    public class NetworkEntityMap : ClassMap<NetworkEntity>
    {

        public NetworkEntityMap()
        {

            Table("network");

            Id(x => x.Id).Column("id").GeneratedBy.Identity();
            Map(x => x.Submask, "submask").Not.Nullable();
            Map(x => x.ExternalIPv4, "external_ip_v4").Not.Nullable();
            Map(x => x.InternalIPv4, "internal_ip_v4").Not.Nullable();
            Map(x => x.DNS, "dns").Not.Nullable();
            Map(x => x.IsLocal, "isLocal").Not.Nullable();
            Map(x => x.Lat, "lat").Not.Nullable();
            Map(x => x.Lng, "lng").Not.Nullable();
            Map(x => x.MAC, "mac").Not.Nullable();
        }

    }
}
