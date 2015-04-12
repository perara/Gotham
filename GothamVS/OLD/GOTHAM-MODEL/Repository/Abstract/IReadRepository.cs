using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Repository.Abstract
{
    public interface IReadRepository<TEntity> where TEntity : class
    {
        IQueryable<TEntity> All();
        TEntity FindBy(Expression<Func<TEntity, bool>> expression);
        TEntity FindBy(object id);
        IQueryable<TEntity> FilterBy(Expression<Func<TEntity, bool>> expression);
    }
}
