using System;

namespace GOTHAM_TOOLS
{
    public static class LongRandom
    {
        static readonly Random Rand = new Random();
        public static long Next(long min, long max)
        {
            var buf = new byte[8];
            Rand.NextBytes(buf);
            var longRand = BitConverter.ToInt64(buf, 0);

            return (Math.Abs(longRand % (max - min)) + min);
        }
    }
}
