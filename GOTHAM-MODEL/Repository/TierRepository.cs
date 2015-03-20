using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

using GOTHAM.Model2;

namespace GOTHAM.Repository
{
  public class TierRepository : IRepositoryInterface<Tier>
  {
    Tier context = new Tier();


    public void Dispose()
    {
      
    }

    public IQueryable<Tier> All
    {
      get { return context.Tiers; }
    }

    public IQueryable<Tier> AllIncluding(params Expression<Func<Tier, object>>[] includeProperties)
    {
      throw new NotImplementedException();
    }

    public Tier Find(int id)
    {
      throw new NotImplementedException();
    }

    public void InsertOrUpdate(Tier entity)
    {
      throw new NotImplementedException();
    }

    public void Delete(int id)
    {
      throw new NotImplementedException();
    }

    public void Save()
    {
      throw new NotImplementedException();
    }
  }
}
