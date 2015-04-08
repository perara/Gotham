using System;

namespace GOTHAM_TOOLS
{
    public class IpAddr
    {
        public string IpStr { get; set; }
        public byte[] Bytes { get; set; }

        /// <summary>
        /// Generated a MAC address object with the input of a string where each hex value is separated with :
        /// </summary>
        /// <param name="address"></param>
        public IpAddr(string address)
        {
            IpStr = address;

            Bytes = new byte[6];
            var strBytes = IpStr.Split('.');

            for (var i = 0; i < strBytes.Length; i++) 
                Bytes[i] = Convert.ToByte(strBytes[i], 16);
        }
    }
}
