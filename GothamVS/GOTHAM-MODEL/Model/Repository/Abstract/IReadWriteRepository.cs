using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Repository.Abstract
{
    public interface IReadWriteRepository<TEntity> : IReadRepository<TEntity>, IWriteRepository<TEntity>
        where TEntity : class { }
}
