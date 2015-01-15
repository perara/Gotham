using FluentNHibernate.Mapping;

namespace GOTHAM.Gotham.Application.Model
{
  public class CableTypeEntityMap : ClassMap<CableTypeEntity>
  {

    public CableTypeEntityMap()
    {
      Id(x => x.id).GeneratedBy.Identity();
      Map(x => x.name);


    }
   

  }
}
