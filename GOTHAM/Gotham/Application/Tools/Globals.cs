using GOTHAM.Tools;
using GOTHAM.Model.Tools;
using GOTHAM.Model;

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NHibernate;
using NHibernate.Linq;


namespace GOTHAM.Tools
{
    public class Globals
    {


        private static Globals INSTANCE = new Globals();

        public static Globals GetInstance()
        {
            return INSTANCE;
        }
        private Globals()
        {
            DateTime time = DateTime.Now;
            // TODO: Preload fra database
            nodes = getTable<NodeEntity>();

            log.Info((DateTime.Now - time).Seconds + "." + (DateTime.Now - time).Milliseconds);
            //cables = getTable<CableEntity>();
        }

        public List<NodeEntity> nodes;
        public List<CableEntity> cables;

        // Global variables and objects
        public Point mapMax = new Point(1000, 1000);

        public readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // Convert to human readable bandwidth
        readonly string[] SizeSuffixes = { "bytes", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb", "Zb", "Yb" };
        public string BWSuffix(double value)
        {
            if (value < 0) { return "-" + BWSuffix(-value); }
            if (value == 0) { return "0.0 bytes"; }

            int mag = (int)Math.Log(value, 1024);
            decimal adjustedSize = (decimal)value / (1L << (mag * 10));

            return string.Format("{0:n1} {1}", adjustedSize, SizeSuffixes[mag]);
        }

        /// <summary>
        /// Query database for table mapped to type T
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>

        public List<T> getTable<T>()
        {
            // SELECT * FROM X
            // SELECT * FROM X where Y = Z and Z = KUK

            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {

                Type typeParameterType = typeof(T);
                var data = session
                   
                    .CreateCriteria(typeParameterType)
                    .SetCacheable(true)
                    .SetCacheMode(CacheMode.Normal)
                    .List<T>()
                    .ToList();
                return data;
            }
        }
    }
}
