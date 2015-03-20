using Funq;
using GOTHAM.Service.ServiceStack.Resources;
using ServiceStack;

namespace GOTHAM.Service.ServiceStack
{
  public class AppHost : AppHostBase
  {
    public AppHost() : base("MyApp's REST services", 
      typeof(HelloResource.HelloService).Assembly,
      typeof(NodeResource.NodeService).Assembly) {}


    public override void Configure(Container container){}

  }
}
