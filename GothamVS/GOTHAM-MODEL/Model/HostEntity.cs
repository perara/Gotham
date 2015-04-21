﻿using System.Diagnostics.CodeAnalysis;
using FluentNHibernate.Mapping;
using Gotham.Tools;

namespace Gotham.Model
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
        public virtual IdentityEntity Owner { get; set; }
        public virtual NodeEntity Node { get; set; }

        // TODO: Use IP and MAC classes. (Exists in Tools project)
        public virtual string Ip { get; set; }
        public virtual string Mac { get; set; }

        // Location
        public virtual double Lat { get; set; }
        public virtual double Lng { get; set; }

        // Filesystem
        public virtual FilesystemEntity Filesystem { get; set; }

        /// <summary>
        /// Empty Constructor for NHIbernate
        /// </summary>
        protected HostEntity() { }


        /// <summary>
        /// HostEntity Constructor 
        /// </summary>
        /// <param name="owner">The IdentityEntity which is the owner</param>
        /// <param name="node">The NodeEntity which is the connected node</param>
        public HostEntity(IdentityEntity owner, NodeEntity node)
        {
            Owner = owner;
            Node = node;

            // TODO - The should be generated by something else. (For example nodeentity)
            Lat = owner.Lat;
            Lng = owner.Lng;
        }


        /// <summary>
        /// Converts Latitude and Longitude strings to Cooordinate object
        /// </summary>
        /// <returns></returns>
        public virtual Coordinate.LatLng GetCoords()
        {
            return new Coordinate.LatLng(Owner.Lat, Owner.Lng);
        }
    }


    /// <summary>
    /// HostEntity Mapping
    /// </summary>
    public class HostEntityMap : ClassMap<HostEntity>
    {
        public HostEntityMap()
        {
            Table("host");
            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.MachineName, "machine_name");
            Map(x => x.Online, "online");
            Map(x => x.Ip, "ip");
            Map(x => x.Mac, "mac");

            References(x => x.Node, "node").Not.LazyLoad().Nullable();
            References(x => x.Owner, "owner").Not.LazyLoad();
            References(x => x.Filesystem, "filesystem").Not.LazyLoad();

            Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
        }
    }
}
