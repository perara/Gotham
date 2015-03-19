using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.MappingModel.Output.Sorting;
using NHibernate.Criterion;
using NUnit.Framework;
using GOTHAM.Tools;
using GOTHAM.Model;
using GOTHAM.Model.Tools;
using GOTHAM.Tools.Cache;

namespace GOTHAM.Gotham.Tests.Tools
{
    [TestFixture]
    class NodeTest
    {

        [Test]
        public void TEST_NodeConsistency()
        {
            var nodes = CacheEngine.Nodes;

            foreach (var node in nodes)
            {
                Assert.NotNull(node.cables, "Node with ID " + node.id + "'s cables are null");
                Assert.Greater(node.cables.Count, 0, "Node with ID " + node.id + " is not connected to any cables");
                Assert.IsNotEmpty(node.name, "Node with ID " + node.id + " does not have a name");
                Assert.AreEqual(node.countryCode.Count(), 2, "Node with ID " + node.id + " has a long countrycode. Is this country name?");
            }
        }


        // TODO Complete?
        [Test]
        public void TEST_TotalBandwidthConsistency()
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
