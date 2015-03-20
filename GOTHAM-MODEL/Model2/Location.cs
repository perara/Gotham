using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model2
{
  public class Location : Context
  {
    public DbSet<Location> Locations { get; set; }

    public int id { get; set; }

    public string countrycode { get; set; }

    public string name { get; set; }

    public double lat { get; set; }
    public double lng { get; set; }



    protected override void OnModelCreating(DbModelBuilder modelBuilder)
    {
      modelBuilder.Entity<Tier>().ToTable("location");
      base.OnModelCreating(modelBuilder);
    }








  }
}
