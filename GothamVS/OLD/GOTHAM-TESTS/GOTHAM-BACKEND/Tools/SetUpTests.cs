using GOTHAM.Application.Tools.Cache;
using NUnit.Framework;

namespace GOTHAM_TESTS.Tools
{
    [SetUpFixture]
    public class SetUpTests
    {
        [SetUp]
	    public void RunBeforeAnyTests()
	    {
            CacheEngine.Init();
	    }

        [TearDown]
	    public void RunAfterAnyTests()
	    {
	        
	    }
    }
}
