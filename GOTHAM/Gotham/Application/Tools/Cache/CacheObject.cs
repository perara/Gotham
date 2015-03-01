using GOTHAM.Model.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Tools.Cache
{
    public class CacheObject <T> : List<T>
    {

        public CacheObject(List<T> newObjects)
        {
            newObjects.ForEach(item => this.Add(item));
        }

        public void Refresh(int index)
        {
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                // Åpne session
                // Refresh object på index pos
                // close sessio
                session.Refresh(this[index]);
            }
        }

        public void RefreshAll()
        {
            // Server ska kalkulera Node X
            // Klient Oppdatere båndbrede på NodeEntity@123
            // Server iterere igjennom Liste
            // Server komme te NodeEntity@123 i listen  ^
            // Server har oppdaterte versjon            |



           // var count = 0;
            //this.ForEach(item => Refresh(count++));
        }
        

    }
}
