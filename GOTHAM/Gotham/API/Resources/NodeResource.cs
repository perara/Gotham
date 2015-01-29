using GOTHAM.Model;
using GOTHAM.Model.Tools;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
      public List<NodeEntity> Any(NodeList n)
      {
        var nodes = Globals.GetInstance().getTable<NodeEntity>();
     
        return nodes;
      }


    }

  }
}
