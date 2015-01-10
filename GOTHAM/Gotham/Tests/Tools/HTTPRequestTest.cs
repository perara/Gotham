using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using NUnit.Framework;

namespace GOTHAM.Gotham.Tests.Tools
{

  class HTTPRequestTest
  {

    [Test]
    public void POST_Test()
    {
      // Response with "Created" http://postcatcher.in/catchers/54b146db2310af02000014fc

      // Test POST Request
      String postTest = new Gotham.Tools.HTTPRequest()
      .POST()
      .setURL("http://postcatcher.in/catchers/54b146db2310af02000014fc")
      .addPostData("test", "lol")
      .execute();

      Assert.AreEqual(postTest, "Created");
    }

    [Test]
    public void GET_Test()
    {
      // Response with IP

      // Test GET Request
      String getTest = new Gotham.Tools.HTTPRequest()
        .GET()
        .setURL("http://ip.jsontest.com/")
        .execute();

      
      dynamic result = JObject.Parse(getTest);

      IPAddress outIp;
      Assert.True(IPAddress.TryParse((String)result.ip, out outIp));
    }



  }
}
