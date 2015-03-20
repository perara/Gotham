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

namespace GOTHAM.Tests
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
                Assert.NotNull(node.Cables, "Node with ID " + node.Id + "'s cables are null");
                Assert.Greater(node.Cables.Count, 0, "Node with ID " + node.Id + " is not connected to any cables");
                Assert.IsNotEmpty(node.Name, "Node with ID " + node.Id + " does not have a name");
                Assert.AreEqual(node.CountryCode.Count(), 2, "Node with ID " + node.Id + " has a long countrycode. Is this country name?");
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
