using System;
using System.Collections.Generic;
using System.Linq;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using GOTHAM.Tools;
using GOTHAM.Traffic.Misc;
using NHibernate.Linq;

namespace GOTHAM.Application.Tools
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
            var work = new UnitOfWork();
            var nodes = work.GetRepository<NodeEntity>().All().ToList();
            work.Dispose();

            var rndPerson = GetHost(false);
            var node = CableGenerator.GetClosestNode(rndPerson, nodes);

            return new HostEntity(rndPerson, node);
        }

        public static HostEntity GetBusinessHost()
        {
            var work = new UnitOfWork();
            var nodes = work.GetRepository<NodeEntity>().All().ToList();
            work.Dispose();

            var rndPerson = GetHost(true);
            var node = CableGenerator.GetClosestNode(rndPerson, nodes);

            return new HostEntity(rndPerson, node);
        }


        public static Session CreateSession(HostEntity source, HostEntity target, Stack<Packet> packets = null)
        {
            var session = new Session(source, target) {Packets = packets};
            return session;
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

        public static Connection NewConnection(HostEntity source, List<Session> sessions = null)
        {
            var con = new Connection(source) {Sessions = sessions ?? new List<Session>()};
            return con;
        }
    }
}
