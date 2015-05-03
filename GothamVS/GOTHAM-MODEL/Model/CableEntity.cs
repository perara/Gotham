using FluentNHibernate.Mapping;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using Newtonsoft.Json;

namespace Gotham.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class CableEntity : BaseEntity
    {
        public virtual int Priority { get; set; }
        public virtual double Capacity { get; set; }
        public virtual double Distance { get; set; }
        public virtual string Name { get; set; }
        public virtual int Year { get; set; }
        //public virtual CableTypeEntity Type { get; set; }
        public virtual int Type { get; set; }

        public virtual IList<NodeEntity> Nodes { get; set; }

        public virtual IList<CablePartEntity> CableParts { get; set; }

        protected CableEntity() { }
        public CableEntity(string name = "NoName")
        {
            Name = name;
        }
        public CableEntity(double capacity, CableTypeEntity type, double distance, string name)
        {
            Capacity = capacity;
            Type = type.Id;
            Distance = distance;
            Name = name;
        }
    }

    public class CableEntityMap : ClassMap<CableEntity>
    {

        public CableEntityMap()
        {
            Table("cable");


            Id(x => x.Id).GeneratedBy.Identity();

            Map(x => x.Priority);
            Map(x => x.Capacity);
            Map(x => x.Distance);
            Map(x => x.Name);
            Map(x => x.Year);
            Map(x => x.Type);


            // Cable Parts, No further loading
            HasMany(x => x.CableParts)
             .Cascade.All()
             .Inverse()
             .KeyColumn("cable")
             .Not.LazyLoad();


            //References(x => x.Type, "type");

            HasManyToMany(x => x.Nodes)
                .Cascade.All()
                .Table("node_cable")
                .ParentKeyColumn("cable")
                .ChildKeyColumn("node")
                .Not.LazyLoad();

            Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
        }

    }
}
