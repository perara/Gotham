using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Application.Tools.Cache;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace GOTHAM.Service.SignalR.Hubs
{
    public class Terminal : Hub
    {

        public void GetTerminal()
        {
            Console.WriteLine(":D");
            Clients.Client(Context.ConnectionId).getTerminal(JsonConvert.SerializeObject(CacheEngine.Hosts[0]));
        }


    }
}
