using FluentNHibernate.Mapping;
using GOTHAM.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class NodeEntity : BaseEntity
    {
        public virtual string name { get; set; }
        public virtual string country { get; set; }
        public virtual TierEntity tier { get; set; }
        public virtual int priority { get; set; }
        public virtual double bandwidth { get; set; }
        public virtual double latitude { get; set; }
        public virtual double longitude { get; set; }

        /// <summary>
        /// neighbors node, This can only be a node within the same Tier level
        /// </summary>
        public virtual IList<NodeEntity> siblings { get; set; }
        public virtual IList<CableEntity> cables { get; set; }

        //[Transient]
        public virtual Coordinate.LatLng GetCoordinates()
        {
            return new Coordinate.LatLng(latitude, longitude);
        }
    }

    public class NodeEntityMap : ClassMap<NodeEntity>
    {

        public NodeEntityMap()
        {
            Table("node");

            Id(x => x.id).Column("id").GeneratedBy.Identity();
            Map(x => x.name).Not.Nullable();
            Map(x => x.country).Not.Nullable();
            Map(x => x.bandwidth).Not.Nullable();
            Map(x => x.latitude).Not.Nullable();
            Map(x => x.longitude).Not.Nullable();

            //HasOne(x => x.tier);
            References(x => x.tier).Not.Nullable().Column("tier");

            HasMany(x => x.siblings)
             .KeyColumn("id")
             .Inverse()
             .Cascade
             .AllDeleteOrphan().Not.LazyLoad();

            HasManyToMany(x => x.cables)
                .Cascade.All()
                .Table("node_cable");

            //HasManyToMany(x => x.cables)
            //   .Table("node_cable")
            //   .ParentKeyColumn("cable")
            //   .ChildKeyColumn("cable")
            //   .Cascade.All();

        }
    }
}
