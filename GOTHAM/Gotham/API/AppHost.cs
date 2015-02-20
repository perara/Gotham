using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceStack;
using Funq;

namespace GOTHAM.API
{
  public class AppHost : AppHostBase
  {
    public AppHost() : base("MyApp's REST services", 
      typeof(HelloResource.HelloService).Assembly,
      typeof(NodeResource.NodeService).Assembly) {}


    public override void Configure(Container container){}

  }
}
