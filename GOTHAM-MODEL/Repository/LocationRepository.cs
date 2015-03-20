using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

using GOTHAM.Model2;

namespace GOTHAM.Repository
{
  public class LocationRepository : IRepositoryInterface<Location>
  {
    Location context = new Location();


    public void Dispose()
    {
      
    }

    public IQueryable<Location> All
    {
      get { return context.Locations; }
    }

    public IQueryable<Location> AllIncluding(params Expression<Func<Location, object>>[] includeProperties)
    {
      throw new NotImplementedException();
    }

    public Location Find(int id)
    {
      throw new NotImplementedException();
    }

    public void InsertOrUpdate(Location entity)
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
