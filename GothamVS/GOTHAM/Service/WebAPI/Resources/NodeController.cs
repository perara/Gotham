using System.Linq;
using System.Web.Http;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using System;
using System.Collections.Generic;
using GOTHAM.Tools;
using NHibernate;
using NHibernate.Linq;


namespace GOTHAM.Service.WebAPI.Resources
{
    public class NodeController : ApiController
    {


        public object GetNodes()
        {

            
            /*
            var work = new UnitOfWork();
            var nodes = work.GetRepository<NodeEntity>().All().ToArray();
            var cables = work.GetRepository<CableEntity>().All().ToArray();
            work.Dispose();
             */

            var cables = new List<CableEntity>();
            var nodes = new List<NodeEntity>();
            var factory = EntityManager.GetSessionFactory();
            using (var session = factory.OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {

                    DateTime startTime = DateTime.Now;
                    nodes = session.Query<NodeEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    cables = session.Query<CableEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    Console.WriteLine(DateTime.Now - startTime);

                    startTime = DateTime.Now;
                    nodes = session.Query<NodeEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    cables = session.Query<CableEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    Console.WriteLine(DateTime.Now - startTime);

                    transaction.Commit();
                }

            }


            using (var session = factory.OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {

                    DateTime startTime = DateTime.Now;
                    nodes = session.Query<NodeEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    cables = session.Query<CableEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    Console.WriteLine(DateTime.Now - startTime);

                    startTime = DateTime.Now;
                    nodes = session.Query<NodeEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    cables = session.Query<CableEntity>().Cacheable().CacheMode(CacheMode.Normal).ToList();
                    Console.WriteLine(DateTime.Now - startTime);

                    transaction.Commit();
                }

            }



            


            return new
            {
                nodes = nodes,
                cables = cables
            };
        }
    }
}
