using FluentNHibernate.Mapping;
using System.Collections.Generic;

namespace GOTHAM.Model
{
    public class CableEntity : BaseEntity
    {

        public virtual int priority { get; set; }
        public virtual double capacity { get; set; }
        public virtual CableTypeEntity type { get; set; }
        public virtual double distance { get; set; }
        public virtual string name { get; set; }
        public virtual int year { get; set; }
        public virtual IList<NodeEntity> nodes { get; set; }
        public virtual IList<CablePartEntity> cableParts { get; set; }
    }
    public class CableEntityMap : ClassMap<CableEntity>
    {

        public CableEntityMap()
        {
            Table("cable");

            Id(x => x.id).GeneratedBy.Identity();

            Map(x => x.priority);
            Map(x => x.capacity);
            Map(x => x.distance);
            Map(x => x.name);
            Map(x => x.year);
       
  
            References(x => x.type, "id").ReadOnly().Not.Nullable();

            HasMany<CablePartEntity>(x => x.cableParts)
            .Inverse()
            .KeyColumn("cable")
            .Not.LazyLoad();

            HasManyToMany(x => x.nodes)
                .Cascade.All()
                .Inverse()
                .Table("node_cable")
                .ParentKeyColumn("cable")
                .ChildKeyColumn("node")
                .Not.LazyLoad();

            //HasMany(x => x.cableParts);
            //HasMany(x => x.cableParts)
            // .KeyColumn("id")
            // .Inverse()
            // .Cascade
            // .AllDeleteOrphan();
            //References(x => x.Node1, "id").Column("node_1").ForeignKey("Id").Fetch.Join();
            //References(x => x.Node2, "id").Column("node_2").ForeignKey("Id").Fetch.Join();
        }

    }
}
