using GOTHAM.Tools;
using GOTHAM.Model;
using ServiceStack;
using System;
using Newtonsoft.Json.Linq;
using GOTHAM.Tools.Cache;


namespace GOTHAM.Gotham.Service.ServiceStack.Resources
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

        JArray ret = new JArray();

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
