using System;
using System.Linq;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;
using NHibernate;

namespace GOTHAM.Service.SignalR.Hubs
{
    public class Terminal : Hub
    {

        public void GetTerminal()
        {

            // Fetch Host
            
            var work = new UnitOfWork();
            var hosts = work.GetRepository<HostEntity>().All().ToList();
            var host = hosts[0];
            work.Dispose();
           


            Clients.Client(Context.ConnectionId).getTerminal(JsonConvert.SerializeObject(host));
        }


    }
}
