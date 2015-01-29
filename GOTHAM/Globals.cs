using GOTHAM.Model;
using GOTHAM.Model.Tools;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM
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
            // TODO: Hent fra database
        }



        // Global variables and objects
        public Point mapMax = new Point(1000, 1000);

        public List<NodeEntity> rootNodes = new List<NodeEntity>();
        public List<CableEntity> cables = new List<CableEntity>();


        // Convert to human readable bandwidth
        static readonly string[] SizeSuffixes = { "bytes", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb", "Zb", "Yb" };
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
        public IList<T> getTable<T>()
        {
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                Type typeParameterType = typeof(T);
                var data = session.CreateCriteria(typeParameterType).List<T>();
                return data;
            }
        }
    }
}
