using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GOTHAM.Model;
using GOTHAM.Model2;
using NHibernate.Util;

namespace GOTHAM
{
  [DbConfigurationType(typeof(MySql.Data.Entity.MySqlEFConfiguration))]
  public abstract class Context : DbContext
  {

    protected Context() : base("Server=localhost;Database=gotham;Uid=root;Pwd=root;")
    {}
  }
}
