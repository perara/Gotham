using FluentNHibernate.Mapping;

namespace GOTHAM.Model
{
    public class CableTypeEntity : BaseEntity
  {

    public virtual string name { get; set; }

  }

    public class CableTypeEntityMap : ClassMap<CableTypeEntity>
    {

        public CableTypeEntityMap()
        {
            Table("cable_type");
            Id(x => x.id).GeneratedBy.Identity();
            Map(x => x.name);

        }
    }
}
