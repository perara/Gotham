using System.Linq;
using GOTHAM.Repository.Abstract;
using NHibernate.Criterion;
using NUnit.Framework;
using Gotham.Model.Tools;
using Gotham.Model;

namespace Gotham.Tests.Tools
{
    [TestFixture]
    class NodeTest
    {

        [Test]
        public void TEST_NodeConsistency()
        {
            var work = new UnitOfWork();
            var nodes = work.GetRepository<NodeEntity>().All().ToList();
            work.Dispose();

            foreach (var node in nodes)
            {
                Assert.NotNull(node.Cables, "Node with ID " + node.Id + "'s cables are null");
                Assert.Greater(node.Cables.Count, 0, "Node with ID " + node.Id + " is not connected to any cables");
                Assert.IsNotEmpty(node.Name, "Node with ID " + node.Id + " does not have a name");
                Assert.AreEqual(node.CountryCode.Count(), 2, "Node with ID " + node.Id + " has a long countrycode. Is this country name?");
                Assert.NotNull(node.MAC, "Node with ID " + node.Id + " does not have a MAC address");
            }
        }

        [Test]
        public void TEST_AllNodesHaveNetwork()
        {
            var work = new UnitOfWork();
            var nodes = work.GetRepository<NodeEntity>().All().ToList();
            work.Dispose();


            foreach (var node in nodes)
            {
                
                Assert.Greater(node.Networks.Count, 0, "Node with ID " + node.Id + " does not have any networks");


            }



        }


        // TODO Complete?
        [Test]
        public void TEST_TotalBandwidthConsistency()
        {
            var work = new UnitOfWork();
            var tiers = work.GetRepository<TierEntity>().All().ToList();


            // Fetch Nodes for that tier
            foreach (var nodes in tiers.Select(tier => work.GetRepository<NodeEntity>().FilterBy(x => x.Tier == tier).ToList()))
            {
                Assert.NotNull(nodes);
            }

            work.Dispose();
        }
    }
}

