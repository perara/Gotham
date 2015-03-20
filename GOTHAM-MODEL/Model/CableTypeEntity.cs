using FluentNHibernate.Mapping;

namespace GOTHAM.Model
{
    public class CableTypeEntity : BaseEntity
  {

    public virtual string Name { get; set; }

  }

    public class CableTypeEntityMap : ClassMap<CableTypeEntity>
    {

        public CableTypeEntityMap()
        {
            Table("cable_type");
            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.Name);

        }
    }
}
