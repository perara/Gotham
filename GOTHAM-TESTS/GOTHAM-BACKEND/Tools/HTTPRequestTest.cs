using System;
using System.Net;
using GOTHAM_TOOLS;
using Newtonsoft.Json.Linq;
using NUnit.Framework;

namespace GOTHAM_TESTS.Tools
{

    [TestFixture]
    class HttpRequestTest
    {

        [Test]
        public void TEST_Post()
        {
            // Response with "Created" http://postcatcher.in/catchers/54b146db2310af02000014fc

            // Test POST Request
            var postTest = new HttpRequest()
            .Post()
            .SetUrl("http://postcatcher.in/catchers/54b146db2310af02000014fc")
            .AddPostData("test", "lol")
            .Execute();

            Assert.AreEqual(postTest, "Created");
        }

        [Test]
        public void TEST_GetIP()
        {
            // Response with IP

            // Test GET Request
            String getTest = new HttpRequest()
              .Get()
              .SetUrl("http://ip.jsontest.com/")
              .Execute();


            dynamic result = JObject.Parse(getTest);

            IPAddress outIp;
            Assert.True(IPAddress.TryParse((String)result.ip, out outIp));
        }



    }
}
