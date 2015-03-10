using System;
using ServiceStack;
using System.Runtime.Remoting;

namespace GOTHAM.Gotham.Service.ServiceStack
{

  public class ServiceStackConsoleHost : MarshalByRefObject
  {
    private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    static ObjectHandle Handle;
    static AppDomain ServiceStackAppDomain;

    public static void Start()
    {
      // Get the assembly of our host
      var assemblyName = typeof(ServiceStackConsoleHost).Assembly.FullName;

      // Create an AppDomain
      ServiceStackAppDomain = AppDomain.CreateDomain("ServiceStackGotham");

      // Load in our service assembly
      ServiceStackAppDomain.Load(assemblyName);

      // Create instance of our ServiceStack application
      Handle = ServiceStackAppDomain.CreateInstance(assemblyName, "GOTHAM.Gotham.Service.ServiceStack.ServiceStackConsoleHost");

      // Show that the main application is in a separate AppDomain
      log.InfoFormat("Main Application is running in AppDomain '{0}'", AppDomain.CurrentDomain.FriendlyName);
    }

    public static void Stop()
    {
      if (ServiceStackAppDomain == null)
        return;

      // Notify ServiceStack that the AppDomain is going to be unloaded
      var host = (ServiceStackConsoleHost)Handle.Unwrap();
      host.Shutdown();

      // Shutdown the ServiceStack application
      AppDomain.Unload(ServiceStackAppDomain);

      ServiceStackAppDomain = null;
    }

    public static void Restart()
    {
      Stop();
      log.Info("Restarting ...");
      Start();

    }

    readonly ServiceStack appHost;

    public ServiceStackConsoleHost()
    {
      appHost = new ServiceStack();
      appHost.Init();
      appHost.Start("http://*:8090/");
      log.InfoFormat("ServiceStack is running in AppDomain '{0}'", AppDomain.CurrentDomain.FriendlyName);
    }

    public void Shutdown()
    {
      if (appHost != null)
      {
        log.Info("Shutting down ServiceStack host");
        if (appHost.HasStarted)
          appHost.Stop();
        appHost.Dispose();
      }
    }
  }

  public class ServiceStack : AppSelfHostBase
  {
    public ServiceStack()
      : base("My ServiceStack Service", typeof(ServiceStack).Assembly)
    {
    }

    public override void Configure(Funq.Container container)
    {
    }
  }
}