using FluentNHibernate.Mapping;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace GOTHAM.Model
{
    public class CableEntity : BaseEntity
    {
        public virtual int priority { get; set; }
        public virtual double capacity { get; set; }
        public virtual double distance { get; set; }
        public virtual string name { get; set; }
        public virtual int year { get; set; }

        [JsonIgnore] //TODO - Why is it bugged in JSONconvert?
        public virtual CableTypeEntity type { get; set; }

        [JsonIgnore]
        public virtual IList<NodeEntity> nodes { get; set; }

        public virtual IList<int> nodeids { get; set; }

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

            References(x => x.type, "id").Not.Nullable();

            HasMany<CablePartEntity>(x => x.cableParts)
            .Cascade.All()
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


            HasManyToMany(x => x.nodeids)
                .Cascade.All()
                .Inverse()
                .Table("node_cable")
                .ParentKeyColumn("cable")
                .ChildKeyColumn("node")
                .Element("node")
                .AsBag()
                .Not.LazyLoad();

        }

    }
}
