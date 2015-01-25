using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class PersonEntity : BaseEntity
    {
        public virtual string name { get; set; }
        /*public virtual string address { get; set; }
        public virtual string phone { get; set; }
        public virtual string email { get; set; }
        public virtual string username { get; set; }
        public virtual string password { get; set; }
        public virtual string birthday { get; set; }
        public virtual string masterCard { get; set; }
        public virtual string occupation { get; set; }
        public virtual string company { get; set; }
        public virtual string vehicle { get; set; }
        public virtual string bloodType { get; set; }
        public virtual string weight{ get; set; }
        public virtual string height{ get; set; }
        public virtual string coordinates { get; set; }*/

    }

    public class PersonEntityMap : ClassMap<PersonEntity>
    {

        public PersonEntityMap()
        {
            Table("person");
            Id(x => x.id).GeneratedBy.Identity();
            Map(x => x.name).Not.Nullable();


        }
    }

}
