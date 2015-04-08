using GOTHAM.Model;
using GOTHAM.Repository.Abstract;
using NHibernate;

namespace GOTHAM.Repository
{
    public class NodeRepository : Repository<NodeEntity>, INodeRepository
    {
        public NodeRepository(ISession session) : base(session) {}
    }


    public interface INodeRepository : IReadWriteRepository<NodeEntity>{}
}
