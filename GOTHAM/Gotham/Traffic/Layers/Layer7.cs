using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Traffic
{
    public class HTTP : Layer7
    {
        public HTTP()
        {
            type = l7_type.HTTP;
        }
    }
    public class FTP : Layer7
    {
        public FTP()
        {
            type = l7_type.FTP;
        }
    }
    public class DNS : Layer7
    {
        public DNS()
        {
            type = l7_type.DNS;
        }
    }
    public class HTTPS : Layer7
    {
        public HTTPS()
        {
            type = l7_type.HTTPS;
        }
    }
    public class SFTP : Layer7
    {
        public SFTP()
        {
            type = l7_type.SFTP;
        }
    }
    public class SSH : Layer7
    {
        public SSH()
        {
            type = l7_type.SSH;
        }
    }
}
