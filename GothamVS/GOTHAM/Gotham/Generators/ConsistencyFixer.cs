using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gotham.Application.Generators;
using Gotham.Model;
using Gotham.Tools;
using GOTHAM.Repository.Abstract;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NHibernate.Event;

namespace Gotham.Gotham.Generators
{
    public class ConsistencyFixer
    {
        public static ConsistencyFixer INSTANCE = new ConsistencyFixer();

        public static ConsistencyFixer GetInstance()
        {
            return INSTANCE;
        }
        private ConsistencyFixer()
        { }


        /// <summary>
        /// This function connect each of the sea cables to nodes
        /// </summary>
        public void ConnectSeaCables()
        {
            var work = new UnitOfWork();

            var repo = work.GetRepository<CableEntity>();
            var seaCables = repo.All().ToList().Where(x => x.Type == 1);

            work.Dispose();

            var newNodes = new List<NodeEntity>();
            var newConnections = new List<NodeCableEntity>();

            foreach(var cable in seaCables)
            {
                foreach (var part in cable.CableParts)
                {

                    var response = new HttpRequest()
                        .Get()
                        .SetUrl(
                            ("http://nominatim.openstreetmap.org/reverse?format=json&lat="+part.Lat+"&lon="+part.Lng+"&zoom=18&addressdetails=1").Replace(",","."))
                        .Execute();

                    Debug.WriteLine(("http://nominatim.openstreetmap.org/reverse?format=json&lat=" + part.Lat + "&lon=" + part.Lng + "&zoom=18&addressdetails=1").Replace(",","."));
                    Debug.WriteLine("\t"+response);
                    var obj = JObject.Parse(response);

                    if (obj.GetValue("error") != null)
                    {
                        continue;
                    }

                    if (obj.GetValue("address")["country_code"] == null)
                    {
                        continue;
                    }


                    // Create Node

                    var lat = part.Lat;
                    var lng = part.Lng;

                    var countryCode = obj.GetValue("address")["country_code"].ToString();

    
       
                    var name = obj.GetValue("display_name").ToString().Split(',')[0];
                    var tier = new TierEntity() {Id = 1};

                    var node = new NodeEntity(name, countryCode, tier, lat, lng);

                    if (newNodes.Exists(x => x.Lat == node.Lat && x.Lng == node.Lng)) continue;

                    newNodes.Add(node);
                    newConnections.Add(CableGenerator.Connect(cable, node));
                }
            }

            work = new UnitOfWork();

            var connections = work.GetRepository<NodeCableEntity>();
            var nodes = work.GetRepository<NodeEntity>();

            connections.Add(newConnections);
            nodes.Add(newNodes);

            work.Dispose();

        }
    }
}
