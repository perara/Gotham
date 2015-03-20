using System;
using System.Runtime.Remoting;
using ServiceStack;

namespace GOTHAM.Service.ServiceStack
{

  public class ServiceStackConsoleHost : MarshalByRefObject
  {
    private static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

    static ObjectHandle _handle;
    static AppDomain _serviceStackAppDomain;

    public static void Start()
    {
      // Get the assembly of our host
      var assemblyName = typeof(ServiceStackConsoleHost).Assembly.FullName;

      // Create an AppDomain
      _serviceStackAppDomain = AppDomain.CreateDomain("ServiceStackGotham");

      // Load in our service assembly
      _serviceStackAppDomain.Load(assemblyName);

      // Create instance of our ServiceStack application
      _handle = _serviceStackAppDomain.CreateInstance(assemblyName, "GOTHAM.Gotham.Service.ServiceStack.ServiceStackConsoleHost");

      // Show that the main application is in a separate AppDomain
      Log.InfoFormat("Main Application is running in AppDomain '{0}'", AppDomain.CurrentDomain.FriendlyName);
    }

    public static void Stop()
    {
      if (_serviceStackAppDomain == null)
        return;

      // Notify ServiceStack that the AppDomain is going to be unloaded
      var host = (ServiceStackConsoleHost)_handle.Unwrap();
      host.Shutdown();

      // Shutdown the ServiceStack application
      AppDomain.Unload(_serviceStackAppDomain);

      _serviceStackAppDomain = null;
    }

    public static void Restart()
    {
      Stop();
      Log.Info("Restarting ...");
      Start();

    }

    readonly ServiceStack _appHost;

    public ServiceStackConsoleHost()
    {
      _appHost = new ServiceStack();
      _appHost.Init();
      _appHost.Start("http://*:8090/");
      Log.InfoFormat("ServiceStack is running in AppDomain '{0}'", AppDomain.CurrentDomain.FriendlyName);
    }

    public void Shutdown()
    {
      if (_appHost != null)
      {
        Log.Info("Shutting down ServiceStack host");
        if (_appHost.HasStarted)
          _appHost.Stop();
        _appHost.Dispose();
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