using GOTHAM.Tools.Cache;
using NUnit.Framework;
using System;

namespace GOTHAM.Tests
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
