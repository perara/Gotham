using System;
using System.Linq;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace GOTHAM.Service.SignalR.Hubs
{
    public class Terminal : Hub
    {

        public void GetTerminal()
        {
            Console.WriteLine(":D");


            // Fetch Host
            var work = new UnitOfWork();
            var hosts = work.GetRepository<HostEntity>().All().ToList();
            work.Dispose();


            Clients.Client(Context.ConnectionId).getTerminal(JsonConvert.SerializeObject(hosts[0]));
        }


    }
}
