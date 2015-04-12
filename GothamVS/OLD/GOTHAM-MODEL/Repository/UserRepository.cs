using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using NHibernate;
using NHibernate.Linq;

namespace GOTHAM.Repository
{
    public class UserRepository : Repository<UserEntity>, IUserRepository
    {
        public UserRepository(ISession session) : base(session){}

        public IEnumerable<UserEntity> Find(string username)
        {
            return _session.Query<UserEntity>().Where(x => x.Username.StartsWith(username));
        }
    }

    public interface IUserRepository : IReadWriteRepository<UserEntity>
    {
        IEnumerable<UserEntity> Find(string username);

    }
}
