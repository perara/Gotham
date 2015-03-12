using GOTHAM.Tools.Cache;
using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Microsoft.Owin.Cors;
using Microsoft.Owin.Hosting;
using Newtonsoft.Json;
using Owin;
using System;
using System.Threading.Tasks;


[assembly: OwinStartup(typeof(GOTHAM.Gotham.Service.SignalR.Startup))]
namespace GOTHAM.Gotham.Service.SignalR
{
  public class SignalR
  {
    public SignalR()
    { }

    public void Start()
    {
      // This will *ONLY* bind to localhost, if you want to bind to all addresses
      // use http://*:8080 to bind to all addresses. 
      // See http://msdn.microsoft.com/en-us/library/system.net.httplistener.aspx 
      // for more information.
      string url = "http://*:8091";
      WebApp.Start(url);
      Console.WriteLine("Server running on {0}", url);

    }

    public void Stop()
    {
  
    }
  }

  class Startup
  {
    public void Configuration(IAppBuilder app)
    {
      app.UseCors(CorsOptions.AllowAll);

      var hubConfiguration = new HubConfiguration();
      hubConfiguration.EnableDetailedErrors = true;

      app.MapSignalR("/gotham", hubConfiguration);
    }
  }

  public class ContosoChatHub : Hub
  {
    public override Task OnConnected()
    {
      // Add your own code here.
      // For example: in a chat application, record the association between
      // the current connection ID and user name, and mark the user as online.
      // After the code in this method completes, the client is informed that
      // the connection is established; for example, in a JavaScript client,
      // the start().done callback is executed.
      Console.WriteLine(":D");
      return base.OnConnected();
    }


    public override Task OnReconnected()
    {
      // Add your own code here.
      // For example: in a chat application, you might have marked the
      // user as offline after a period of inactivity; in that case 
      // mark the user as online again.
      return base.OnReconnected();
    }
  }

}
