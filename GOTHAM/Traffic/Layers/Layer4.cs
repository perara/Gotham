namespace GOTHAM.Traffic.Layers
{
    public class Tcp : Layer4
    {
        //TODO: Sequence numbers for each packet
        public Tcp()
        {
            Type = L4Type.Tcp;
        }
    }


    public class Udp : Layer4
    {
        public Udp()
        {
            Type = L4Type.Udp;
        }
    }
}
