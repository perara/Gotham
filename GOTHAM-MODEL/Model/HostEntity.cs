﻿using System.Diagnostics.CodeAnalysis;
using FluentNHibernate.Mapping;
using GOTHAM_TOOLS;

namespace GOTHAM.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class HostEntity : BaseEntity
    {

        public virtual string MachineName { get; set; }
        public virtual bool Online { get; set; }
        public virtual PersonEntity Owner { get; set; }

        // TODO: Add to database and map
        public virtual NodeEntity Node { get; set; }

        // TODO: Use IP and MAC classes. (Exists in Tools project)
        public virtual string Ip { get; set; }
        public virtual string Mac { get; set; }

        // Location
        public virtual double Lat { get; set; }
        public virtual double Lng { get; set; }

        // Constructors
        protected HostEntity() { }
        public HostEntity(string machineName = "NoName")
        {
            MachineName = machineName;
        }
        public HostEntity(PersonEntity owner, NodeEntity node)
        {
            Owner = owner;
            Lat = owner.Lat;
            Lng = owner.Lng;
            Node = node;
        }
        public virtual Coordinate.LatLng GetCoords()
        {
            return new Coordinate.LatLng(Owner.Lat, Owner.Lng);
        }
    }

    public class HostEntityMap : ClassMap<HostEntity>
    {
        public HostEntityMap()
        {
            Table("host");
            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.MachineName);
            Map(x => x.Online);
            Map(x => x.Ip);
            Map(x => x.Mac);
            References(x => x.Owner);
        }
    }
}
