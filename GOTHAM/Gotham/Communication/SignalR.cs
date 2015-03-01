using GOTHAM.Tools.Cache;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using Microsoft.Owin;
using Microsoft.Owin.Cors;
using Microsoft.Owin.Hosting;
using Newtonsoft.Json;
using Owin;
using System;
using System.Threading.Tasks;

[assembly: OwinStartup(typeof(SignalRChat.Startup))]
namespace SignalRChat
{
    class MakeCon
    {
        public MakeCon()
        {
            // This will *ONLY* bind to localhost, if you want to bind to all addresses
            // use http://*:8080 to bind to all addresses. 
            // See http://msdn.microsoft.com/en-us/library/system.net.httplistener.aspx 
            // for more information.
            string url = "http://*:8091";
            using (WebApp.Start(url))
            {
                Console.WriteLine("Server running on {0}", url);
                Console.ReadLine();
            }
        }
    }

    class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.UseCors(CorsOptions.AllowAll);
            app.MapSignalR("/gotham", new HubConfiguration());
        }
    }

    //[HubName("GothamHub")]
    public class WorldMap : Hub
    {
        public void UpdateAll(string json)
        {
            Clients.All.broadcastMessage(json);
        }

        public void UpdateNode()
        {

            // Sender Update på X node til alle clients
            // 1. Get Node object | Cache
            // 2. Jsonify | "Cache"
            // 3. Send Node object | No Cache
        

        }

        public void RequestMap()
        {
            Clients.Client(Context.ConnectionId).fetchMap(JsonConvert.SerializeObject(CacheEngine.Nodes));

            // Denna her bli kjørt når spillet/frontend starte
            // 1. Get Nodes | Cache
            // 2. Jsonify | Cache
            // 3. Send to client | No Cache

            // For hver scroll
            // 1. Client: Need Update x: 10, y: 20
            // 2. Server: Query | Ikkje cache
            //


        }

        // Sendt from client (Recieved on server)
        public void Send(string name, string message)
        {
            // Call the broadcastMessage method to update clients.
            Clients.All.broadcastMessage(name, message);
            Console.WriteLine("Message sendt from " + name + ": " + message);
            Clients.All.test(name, message);
        }
    }



    public class MicroTraffic : Hub
    {
        public void Update(string message)
        {
            // Call the broadcastMessage method to update clients.
            Clients.All.broadcastMessage(message);
            Console.WriteLine("HUB1, Message sendt from " + ": " + message);
        }

        // Sendt from client (Recieved on server)
        public void Send(string name, string message)
        {
            // Call the broadcastMessage method to update clients.
            Clients.All.broadcastMessage(name, message);
            Console.WriteLine("HUB1, Message sendt from " + name + ": " + message);
        }
    }
}
