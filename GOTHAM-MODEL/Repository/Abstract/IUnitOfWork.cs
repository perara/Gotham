using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Repository.Abstract
{
    public interface IUnitOfWork : IDisposable
    {
        IReadWriteRepository<TEntity> GetRepository<TEntity>() where TEntity : class;
        void Commit();
        void Rollback();
    }
}
