using System.Linq;
using Gotham.Model;
using GOTHAM.Repository.Abstract;
using NUnit.Framework;

namespace Gotham.Tests.Tools
{
    class CableTest
    {
        [Test]
        public void TEST_CableConsistency()
        {
            var work = new UnitOfWork();
            var cables = work.GetRepository<CableEntity>().All().ToList();
            work.Dispose();

            foreach (var cable in cables)
            {
                Assert.NotNull(cable.Nodes, "Cable with ID " + cable.Id + "'s nodes are null");
                Assert.Greater(cable.Nodes.Count, 0, "Cable with ID " + cable.Id + " is not connected to any nodes");
                Assert.IsNotEmpty(cable.Name, "Cable with ID " + cable.Id + " does not have a name");
                Assert.Greater(cable.CableParts.Count, 0, "Cable with ID " + cable.Id + " does not have any cable parts");
                Assert.NotNull(cable.Type, "Cable with ID " + cable.Id + " does not have a cable type");
            }
        }
    }
}
