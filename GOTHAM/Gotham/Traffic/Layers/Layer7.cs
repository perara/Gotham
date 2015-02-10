using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    class HTTP : NoEncryption, ILayer7
    {
        string webServer { get; set; }
        DateTime date { get; set; }
        HostEntity host { get; set; }
        public string data { get; set; }


        public HTTP()
        {
            l7 = l7_type.HTTP;
        }
    }
}
