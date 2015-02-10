using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    class HTTP : NoEncryption_TCP, ILayer7
    {
        public string webServer { get; set; }
        public DateTime date { get; set; }
        public HostEntity host { get; set; }
        public string data { get; set; }


        public HTTP()
        {
            l7 = l7_type.HTTP;
        }
    }
    class RTSP : NoEncryption_UDP, ILayer7
    {
        public string webServer { get; set; }
        public DateTime date { get; set; }
        public HostEntity host { get; set; }
        public string data { get; set; }


        public RTSP()
        {
            l7 = l7_type.HTTP;
        }
    }
}
