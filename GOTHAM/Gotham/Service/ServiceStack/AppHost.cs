using ServiceStack;
using Funq;
using GOTHAM.Gotham.Service.ServiceStack.Resources;

namespace GOTHAM.Gotham.Service.ServiceStack
{
  public class AppHost : AppHostBase
  {
    public AppHost() : base("MyApp's REST services", 
      typeof(HelloResource.HelloService).Assembly,
      typeof(NodeResource.NodeService).Assembly) {}


    public override void Configure(Container container){}

  }
}
