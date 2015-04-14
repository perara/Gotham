using NUnit.Framework;

namespace Gotham.Tests.Tools
{
    [SetUpFixture]
    public class SetUpTests
    {
        [SetUp]
	    public void RunBeforeAnyTests()
	    {
            
	    }

        [TearDown]
	    public void RunAfterAnyTests()
	    {
	        
	    }
    }
}
