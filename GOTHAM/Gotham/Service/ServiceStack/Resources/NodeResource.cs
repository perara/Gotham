using GOTHAM.Tools;
using GOTHAM.Model;
using ServiceStack;
using System;
using Newtonsoft.Json.Linq;


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
          var nodes = DBTool.getTable<NodeEntity>();

        JArray ret = new JArray();

        nodes.ForEach(x => ret.Add( new JObject(
           new JProperty("id", x.id),
           new JProperty("lat", x.lat),
           new JProperty("long", x.lng),
           new JProperty("name", x.name),
           //new JProperty("tier", x.tier),
           new JProperty("country", x.country)
          )));



        return ret.ToString();
      }


    }

  }
}
