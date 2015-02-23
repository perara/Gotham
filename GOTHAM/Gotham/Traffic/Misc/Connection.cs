using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Traffic
{
    public class Connection
    {
        public List<Session> sessions { get; set; }
        public HostEntity host { get; set; }

        public Connection(HostEntity host)
        {
            this.host = host;
        }
    }
}
