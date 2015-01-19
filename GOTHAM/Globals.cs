using GOTHAM.Model;
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
            idCounter = 0;
        }



        // Global variables and objects
        public int idCounter;
        public Point mapMax = new Point(1000, 1000);

        public List<NodeEntity> rootNodes = new List<NodeEntity>();
        public List<CableEntity> cables = new List<CableEntity>();

        public int GetID()
        {
            int id = idCounter;
            idCounter++;
            return id;
        }


        // Convert to human readable banswidth
        static readonly string[] SizeSuffixes = { "bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" };
        public string BWSuffix(double value)
        {
            if (value < 0) { return "-" + BWSuffix(-value); }
            if (value == 0) { return "0.0 bytes"; }

            int mag = (int)Math.Log(value, 1024);
            decimal adjustedSize = (decimal)value / (1L << (mag * 10));

            return string.Format("{0:n1} {1}", adjustedSize, SizeSuffixes[mag]);
        }
    }
}
