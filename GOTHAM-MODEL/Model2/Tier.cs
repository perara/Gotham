using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Model;
using GOTHAM.Model2;

namespace GOTHAM.Model2
{
  public class Tier : Context
  {

    public DbSet<Tier> Tiers { get; set; }

    public int id { get; set; }

    public string name { get; set; }
 

  

    protected override void OnModelCreating(DbModelBuilder modelBuilder)
    {
      modelBuilder.Entity<Tier>().ToTable("tier");
      base.OnModelCreating(modelBuilder);
    }


  }
}
