using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;

namespace GOTHAM.Gotham.Service.SignalR.Hubs
{

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
