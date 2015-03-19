using FluentNHibernate.Mapping;
using GOTHAM.Model;
using GOTHAM.Tools;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NHibernate.Mapping;
using NHibernate.Util;

namespace GOTHAM.Model
{
    public class NodeEntity : BaseEntity
    {
        /// <summary>
        /// Name of the Node
        /// </summary>
        public virtual string name { get; set; }

        /// <summary>
        /// Country of the Node
        /// TODO - Should be Entity
        /// </summary>
        public virtual string countryCode { get; set; }

        /// <summary>
        /// Tier Entity of the Node - (Tier 1, Tier 2, Tier 3)
        /// </summary>
        public virtual TierEntity tier { get; set; }

        /// <summary>
        /// Host Entity of the Node - 
        /// TODO - Support for multiple hosts? Paul - Elaborate?
        /// </summary>
        public virtual HostEntity host { get; set; }

        /// <summary>
        /// Node Priority - This is a weight to determine the speed/importance of the node
        /// </summary>
        public virtual int priority { get; set; }

        /// <summary>
        /// Bandwidth of the node in bytes?
        /// </summary>
        public virtual double bandwidth { get; set; }

        /// <summary>
        /// Latitude
        /// </summary>
        public virtual double lat { get; set; }

        /// <summary>
        /// Longitude
        /// </summary>
        public virtual double lng { get; set; }

        /// <summary>
        /// List of cables connected to this node
        /// </summary>
        [JsonIgnore]
        public virtual IList<CableEntity> cables { get; set; }

        /// <summary>
        /// Function which instantiate a new Coordinate class with LatLng
        /// </summary>
        /// <returns>Coordinate.LatLng instance</returns>
        public virtual Coordinate.LatLng GetCoordinates()
        {
            return new Coordinate.LatLng(lat, lng);
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
            this.name = name;
        }

        /// <summary>
        /// Constructor requiring relevant information
        /// </summary>
        /// <param name="name"></param>
        /// <param name="country"></param>
        /// <param name="tier"></param>
        /// <param name="lat"></param>
        /// <param name="lng"></param>
        public NodeEntity(string name, string countryCode, TierEntity tier, double lat, double lng)
        {
            this.name = name;
            this.countryCode = countryCode;
            this.tier = tier;
            this.lat = lat;
            this.lng = lng;
        }

        /// <summary>
        /// Get all siblings to this node, Done via checking "this" nodes connected cables 
        /// </summary>
        /// <returns>List of nodes, siblings to "this" node</returns>
        private List<NodeEntity> siblings { get; set; }
        public  virtual List<NodeEntity> Siblings(bool forceUpdate = false)
        {
            if(siblings == null || forceUpdate){
                siblings = (from cable in cables from node in cable.nodes where this != node select node).ToList();
            }

            return siblings;
        }


    }

    public class NodeEntityMap : ClassMap<NodeEntity>
    {

        public NodeEntityMap()
        {
            Table("node");

            Id(x => x.id).Column("id").GeneratedBy.Identity();
            Map(x => x.name).Not.Nullable();
            Map(x => x.countryCode).Not.Nullable();
            Map(x => x.bandwidth).Not.Nullable();
            Map(x => x.lat).Not.Nullable();
            Map(x => x.lng).Not.Nullable();

            References(x => x.tier)
                .Not.Nullable()
                .Column("tier")
                .Not.LazyLoad();

            HasManyToMany(x => x.cables)
                .Cascade.All()
                .Table("node_cable")
                .ParentKeyColumn("node")
                .ChildKeyColumn("cable")
                .Not.LazyLoad();
        }
    }
}
