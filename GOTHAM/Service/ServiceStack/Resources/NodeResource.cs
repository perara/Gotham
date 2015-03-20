using System;
using GOTHAM.Application.Tools.Cache;
using Newtonsoft.Json.Linq;
using ServiceStack;

namespace GOTHAM.Service.ServiceStack.Resources
{
  public class NodeResource
  {

    /*[Route("/list")]
    public class NodeReturn
    {
      public string Name { get; set; }
    }*/


    [Route("/list")]
    public class NodeList { }

    /// <summary>
    ///  Service Binder
    /// </summary>
    public class NodeService : IService
    {
      public String Any(NodeList n)
      {
          var nodes = CacheEngine.Nodes;

        var ret = new JArray();

        nodes.ForEach(x => ret.Add( new JObject(
           new JProperty("id", x.Id),
           new JProperty("lat", x.Lat),
           new JProperty("long", x.Lng),
           new JProperty("name", x.Name),
           //new JProperty("tier", x.tier),
           new JProperty("country", x.CountryCode)
          )));



        return ret.ToString();
      }


    }

  }
}
