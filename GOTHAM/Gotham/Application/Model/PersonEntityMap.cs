using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentNHibernate.Mapping;

namespace GOTHAM.Gotham.Application.Model
{
  public class PersonEntityMap : ClassMap<PersonEntity>
  {

    public PersonEntityMap()
    {
      Table("person");


    }
  }
}
