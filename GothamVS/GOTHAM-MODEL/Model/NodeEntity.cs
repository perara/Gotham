using FluentNHibernate.Mapping;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using GOTHAM_TOOLS;

namespace GOTHAM.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class NodeEntity : BaseEntity
    {
        /// <summary>
        /// Name of the Node
        /// </summary>
        public virtual string Name { get; set; }

        /// <summary>
        /// Country of the Node
        /// TODO - Should be Entity
        /// </summary>
        public virtual string CountryCode { get; set; }

        /// <summary>
        /// Tier Entity of the Node - (Tier 1, Tier 2, Tier 3)
        /// </summary>
        public virtual TierEntity Tier { get; set; }

        /// <summary>
        /// Host Entity of the Node - 
        /// TODO - Support for multiple hosts? Paul - Elaborate?
        /// </summary>
        public virtual HostEntity Host { get; set; }

        /// <summary>
        /// Node Priority - This is a weight to determine the speed/importance of the node
        /// </summary>
        public virtual int Priority { get; set; }

        /// <summary>
        /// Bandwidth of the node in bytes?
        /// </summary>
        public virtual double Bandwidth { get; set; }

        /// <summary>
        /// Latitude
        /// </summary>
        public virtual double Lat { get; set; }

        /// <summary>
        /// Longitude
        /// </summary>
        public virtual double Lng { get; set; }

        /// <summary>
        /// List of cables connected to this node
        /// </summary>
        [JsonIgnore]
        public virtual IList<CableEntity> Cables { get; set; }

        /// <summary>
        /// List of cable ids connected tot this node
        /// </summary>
        public virtual IList<int> CableIds { get; set; }

        /// <summary>
        /// Function which instantiate a new Coordinate class with LatLng
        /// </summary>
        /// <returns>Coordinate.LatLng instance</returns>
        public virtual Coordinate.LatLng GetCoords()
        {
            return new Coordinate.LatLng(Lat, Lng);
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        protected NodeEntity() { }

        /// <summary>
        /// "Empty" constructor
        /// </summary>
        /// <param name="name"></param>
        public NodeEntity(string name = "NoName")
        {
            Name = name;
        }

        /// <summary>
        /// Constructor requiring relevant information
        /// </summary>
        /// <param name="name"></param>
        /// <param name="countryCode"></param>
        /// <param name="tier"></param>
        /// <param name="lat"></param>
        /// <param name="lng"></param>
        public NodeEntity(string name, string countryCode, TierEntity tier, double lat, double lng)
        {
            Name = name;
            CountryCode = countryCode;
            Tier = tier;
            Lat = lat;
            Lng = lng;
        }

        /// <summary>
        /// Get all siblings to this node, Done via checking "this" nodes connected cables 
        /// </summary>
        /// <returns>List of nodes, siblings to "this" node</returns>
        private List<NodeEntity> Siblings { get; set; }
        public virtual List<NodeEntity> GetSiblings(bool forceUpdate = false)
        {
            if(Siblings == null || forceUpdate){
                Siblings = (from cable in Cables from node in cable.Nodes where this != node select node).ToList();
            }

            return Siblings;
        }


    }

    public class NodeEntityMap : ClassMap<NodeEntity>
    {

        public NodeEntityMap()
        {
            Table("node");

            Id(x => x.Id).Column("id").GeneratedBy.Identity();
            Map(x => x.Name).Not.Nullable();
            Map(x => x.CountryCode).Not.Nullable();
            Map(x => x.Bandwidth).Not.Nullable();
            Map(x => x.Lat).Not.Nullable();
            Map(x => x.Lng).Not.Nullable();

            References(x => x.Tier)
                .Not.Nullable()
                .Column("tier")
                .LazyLoad();

            HasManyToMany(x => x.Cables)
                .Cascade.All()
                .Table("node_cable")
                .ParentKeyColumn("node")
                .ChildKeyColumn("cable")
                .LazyLoad();

            HasManyToMany(x => x.CableIds)
                .Cascade.All()
                .Table("node_cable")
                .ParentKeyColumn("node")
                .ChildKeyColumn("cable")
                .Element("cable")
                .LazyLoad();


            Cache.NonStrictReadWrite().IncludeAll().Region("LongTerm");
        }
    }
}
