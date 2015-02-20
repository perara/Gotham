using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.MappingModel.Output.Sorting;
using GOTHAM.Gotham.Application;
using NHibernate.Criterion;
using NUnit.Framework;
using GOTHAM.Tools;
using GOTHAM.Model;

namespace GOTHAM.Gotham.Tests.Tools
{
    [TestFixture]
    class NodeTest
    {

        [Test]
        public void Test_TotalBandwidthConsistency()
        {
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {


                var tiers = session
                   .CreateCriteria<TierEntity>()
                   .List<TierEntity>();


                // Fetch Nodes for that tier
                foreach (var tier in tiers)
                {

                    var nodes = session
                      .CreateCriteria<NodeEntity>()
                      .Add(Restrictions.Eq("tier", tier))
                      .List<NodeEntity>();


                }
            }
        }

    }
}
