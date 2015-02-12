using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic.Misc
{
    public class IP
    {
        public string ipStr { get; set; }
        public byte[] bytes { get; set; }

        /// <summary>
        /// Generated a MAC address object with the input of a string where each hex value is separated with :
        /// </summary>
        /// <param name="address"></param>
        public IP(string address)
        {
            ipStr = address;

            bytes = new byte[6];
            var strBytes = ipStr.Split('.');

            for (int i = 0; i < strBytes.Length; i++) 
                bytes[i] = Convert.ToByte(strBytes[i], 16);
        }
    }
}
