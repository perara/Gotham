using GOTHAM.Model;
using GOTHAM.Model.Tools;
using GOTHAM.Traffic;
using System;
using System.Collections.Generic;
using System.Linq;
using NHibernate.Linq;
using GOTHAM.Tools;
using GOTHAM.Tools.Cache;

namespace GOTHAM.Gotham.Application.Tools
{
    public class SessionGenerator
    {
        public static PersonEntity GetHost(bool business)
        {
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                if (business)
                {
                    //TODO Change to coorporate table
                    var totalPersons = session.QueryOver<PersonEntity>().RowCount();
                    var randomId = new Random().Next(0, totalPersons);

                    //TODO Change to coorporate table
                    return session.Query<PersonEntity>().FirstOrDefault(x => x.Id == randomId);
                }
                else
                {
                    var totalPersons = session.QueryOver<PersonEntity>().RowCount();
                    var randomId = new Random().Next(0, totalPersons);

                    return session.Query<PersonEntity>().FirstOrDefault(x => x.Id == randomId);
                }
            }
        }

        public static HostEntity GetPrivateHost()
        {
            var rndPerson = GetHost(false);
            var node = CableGenerator.GetClosestNode(rndPerson, CacheEngine.Nodes);

            return new HostEntity(rndPerson, node);
        }

        public static HostEntity GetBusinessHost()
        {
            var rndPerson = GetHost(true);
            var node = CableGenerator.GetClosestNode(rndPerson, CacheEngine.Nodes);

            return new HostEntity(rndPerson, node);
        }


        public static void CreateSession(HostEntity source, HostEntity target, Stack<Packet> packets = null)
        {

        }

        public static Session NewPrivateToPrivateSession(Stack<Packet> packets = null)
        {
            var source = GetPrivateHost();
            var target = GetPrivateHost();
            return new Session(source, target);
        }

        public static Session NewPrivateToBusinessSession(Stack<Packet> packets = null)
        {
            var source = GetPrivateHost();
            var target = GetBusinessHost();
            return new Session(source, target);
        }
    }
}
