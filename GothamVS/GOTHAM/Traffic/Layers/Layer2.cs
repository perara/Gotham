using GOTHAM.Model;

namespace GOTHAM.Traffic.Layers
{
    public class Ethernet : Layer2
    {
        public Ethernet(HostEntity dest, HostEntity source)
        {
            Type = L2Type.Ethernet;
            Source = source;
            Dest = dest;
        }

        public Ethernet()
        {
            Type = L2Type.Ethernet;
        }
    }

    public class Wifi : Layer2
    {
        public Wifi(HostEntity dest, HostEntity source)
        {
            Type = L2Type.Ethernet;
            Source = source;
            Dest = dest;
        }

        public Wifi()
        {
            Type = L2Type.Ethernet;
        }

    }
}
