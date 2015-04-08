using System;
using System.Linq;
using System.Web.Http;
using GOTHAM.Model;
using GOTHAM.Tools;
using NHibernate.Linq;

namespace GOTHAM.Service.WebAPI.Resources
{

    public class UserController: ApiController
    {

        /// <summary>
        /// Get Currently logged in user
        /// </summary>
        /// <returns>JSON With Currently Logged In user</returns>
        public object GetUser()
        {
            UserEntity user = null;
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                user = session.Query<UserEntity>().Cacheable().CacheRegion("foo").First(x => x.Id == 1); // TODO Fix ID based on authentication token
            }


            return user;
        }




    }
}
