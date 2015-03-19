using GOTHAM.Model;
using GOTHAM.Tools;
using GOTHAM.Tools.Cache;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM_TESTS.GOTHAM_BACKEND.Tools
{
    class CableTest
    {
        [Test]
        public void TEST_CableConsistency()
        {
            var cables = CacheEngine.Cables;

            foreach (var cable in cables)
            {
                Assert.NotNull(cable.nodes, "Cable with ID " + cable.id + "'s nodes are null");
                Assert.Greater(cable.nodes.Count, 0, "Cable with ID " + cable.id + " is not connected to any nodes");
                Assert.IsNotEmpty(cable.name, "Cable with ID " + cable.id + " does not have a name");
                Assert.Greater(cable.cableParts.Count, 0, "Cable with ID " + cable.id + " does not have any cable parts");
                Assert.NotNull(cable.type, "Cable with ID " + cable.id + " does not have a cable type");
            }
        }
    }
}
