using GOTHAM.Model;
using GOTHAM.Model.Tools;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using NHibernate.Util;

namespace GOTHAM.Gotham.API.Resources
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
        var  nodes = Globals.GetInstance().getTable<NodeEntity>();

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
