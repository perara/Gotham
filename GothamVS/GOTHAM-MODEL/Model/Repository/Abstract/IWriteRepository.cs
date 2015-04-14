using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Repository.Abstract
{
    public interface IWriteRepository<TEntity> where TEntity : class
    {
        bool Add(TEntity entity);
        bool Add(IEnumerable<TEntity> entities);
        bool Update(TEntity entity);
        bool Update(IEnumerable<TEntity> entities);
        bool Delete(TEntity entity);
        bool Delete(IEnumerable<TEntity> entities);
    }
}
