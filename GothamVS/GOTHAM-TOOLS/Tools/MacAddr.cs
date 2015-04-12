using System;

namespace Gotham.Tools
{
    public class MacAddr
    {
        public string MacStr { get; set; }
        public byte[] Bytes { get; set; }

        /// <summary>
        /// Generated a MAC address object with the input of a string where each hex value is separated with :
        /// </summary>
        /// <param name="address"></param>
        public MacAddr(string address)
        {
            MacStr = address;

            Bytes = new byte[6];
            var strBytes = MacStr.Split(':');

            for (var i = 0; i < strBytes.Length; i++) 
                Bytes[i] = Convert.ToByte(strBytes[i], 16);
        }
    }
}
