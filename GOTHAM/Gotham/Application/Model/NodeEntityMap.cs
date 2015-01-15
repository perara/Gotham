﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;

namespace GOTHAM.Gotham.Application.Model
{
  public class NodeEntityMap : ClassMap<NodeEntity>
  {

    public NodeEntityMap()
    {
      Table("node");

      Id(x => x.id).GeneratedBy.Identity();
      Map(x => x.name);
      Map(x => x.bandwidth);
      HasOne(x => x.tier);
      HasMany(x => x.siblings)
           .KeyColumn("id")
           .Inverse()
           .Cascade
           .AllDeleteOrphan();
      /*HasManyToMany(x => x.cables)
         .Cascade.All()
         .Table("cable");
      */

    }


  }
}
