using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;

namespace GOTHAM.Model
{
  public class NodeEntityMap : ClassMap<NodeEntity>
  {

    public NodeEntityMap()
    {
      Table("node");
      
      Id(x => x.id).Column("id").GeneratedBy.Identity();
      Map(x => x.name).Not.Nullable();
      Map(x => x.bandwidth).Not.Nullable();
      Map(x => x.latitude).Not.Nullable();
      Map(x => x.longitude).Not.Nullable();
      Map(x => x.tierId).Column("tier").Not.Nullable();
      HasOne(x => x.tier);
      HasMany(x => x.siblings)
         .KeyColumn("id")
         .Inverse()
         .Cascade
         .AllDeleteOrphan().Not.LazyLoad();
      HasManyToMany(x => x.cables)
         .Table("cable")
         .ParentKeyColumn("node_1")
         .ChildKeyColumn("node_2")
         .Cascade.All();

      

    }
  }
}
