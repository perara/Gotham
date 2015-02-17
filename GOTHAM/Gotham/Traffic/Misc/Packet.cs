using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    public class Packet
    {
        public Stack<NodeEntity> path { get; set; }
        public Layer2 l2 { get; set; }
        public Layer3 l3 { get; set; }
        public Layer4 l4 { get; set; }
        public Layer6 l6 { get; set; }
        public Layer7 l7 { get; set; }

        public Packet(Stack<NodeEntity> path)
        {
            newPacket(path);
        }

        /// <summary>
        /// Generates a new packet from spesifications, by default HTTP is generated
        /// </summary>
        /// <param name="path"></param>
        /// <param name="l7Type"></param>
        /// <param name="l4Type"></param>
        /// <param name="l6Type"></param>
        /// <param name="l2Type"></param>
        /// <param name="l3Type"></param>
        public void newPacket(Stack<NodeEntity> path,
            Layer7.l7_type l7Type = Layer7.l7_type.HTTP, 
            Layer4.l4_type l4Type = Layer4.l4_type.TCP,
            Layer6.l6_type l6Type = Layer6.l6_type.none,
            Layer2.l2_type l2Type = Layer2.l2_type.Ethernet,
            Layer3.l3_type l3Type = Layer3.l3_type.IP)
        {

            

            // Set layer 2 type
            switch (l2Type)
            {
                case Layer2.l2_type.Ethernet:
                    l2 = new Ethernet();
                    return;

                case Layer2.l2_type.Wifi:
                    l2 = new WIFI();
                    return;
            }

            // Set layer 3 type
            l3 = new IP();
            

            switch(l7Type){
                case Layer7.l7_type.HTTP:
                    l7 = new HTTP();
                    return;

                case Layer7.l7_type.DNS:
                    l4 = new UDP();
                    l7 = new DNS();
                    return;

                case Layer7.l7_type.FTP:
                    l7 = new FTP();
                    return;

                case Layer7.l7_type.HTTPS:
                    l7 = new HTTPS();
                    return;

                case Layer7.l7_type.SFTP:
                    l7 = new SFTP();
                    return;

                case Layer7.l7_type.SSH:
                    l7 = new SSH();
                    return;

              
            }

            // If no encryption specified. Set l6 to no encryption
            if (l6 == null) l6 = new NoEncryption();
            
        }
        public void newICMP(Stack<NodeEntity> path, Layer2.l2_type l2Type = Layer2.l2_type.Ethernet)
        {
            switch (l2Type)
            {
                case Layer2.l2_type.Ethernet:
                    l2 = new Ethernet();
                    return;

                case Layer2.l2_type.Wifi:
                    l2 = new WIFI();
                    return;
            }

            l3 = new ICMP();
        }
        public Packet()
        {

        }
    }
}
