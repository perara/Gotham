using System;
using System.Drawing;

namespace GOTHAM.Tools
{
    public class Globals
    {
        public readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private static readonly Globals Instance = new Globals();

        public static Globals GetInstance()
        {
            return Instance;
        }
        private Globals()
        {
            
        }
        
        // Global variables and objects
        public Point MapMax = new Point(1000, 1000);

        // Convert to human readable bandwidth
        readonly string[] _sizeSuffixes = { "bytes", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb", "Zb", "Yb" };
        public string BwSuffix(double value)
        {
            if (value < 0) { return "-" + BwSuffix(-value); }
            if (value.Equals(0)) { return "0.0 bytes"; }

            var mag = (int)Math.Log(value, 1024);
            var adjustedSize = (decimal)value / (1L << (mag * 10));

            return string.Format("{0:n1} {1}", adjustedSize, _sizeSuffixes[mag]);
        }
    }
}
