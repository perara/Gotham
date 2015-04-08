using System;

namespace GOTHAM_TOOLS
{
    static class BwTools
    {
        static readonly string[] SizeSuffixes = { "bytes", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb", "Zb", "Yb" };
        public static string BwSuffix(double value)
        {
            if (value < 0) { return "-" + BwSuffix(-value); }
            if (value.Equals(0)) { return "0.0 bytes"; }

            var mag = (int)Math.Log(value, 1024);
            var adjustedSize = (decimal)value / (1L << (mag * 10));

            return string.Format("{0:n1} {1}", adjustedSize, SizeSuffixes[mag]);
        }
    }
}
