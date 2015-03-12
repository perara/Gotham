using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Tools.Cache;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace GOTHAM.Gotham.Service.SignalR.Hubs
{
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
}
