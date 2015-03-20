namespace GOTHAM.Traffic.Layers
{
    public class Http : Layer7
    {
        public Http()
        {
            Type = L7Type.Http;
        }
    }
    public class Ftp : Layer7
    {
        public Ftp()
        {
            Type = L7Type.Ftp;
        }
    }
    public class Dns : Layer7
    {
        public Dns()
        {
            Type = L7Type.Dns;
        }
    }
    public class Https : Layer7
    {
        public Https()
        {
            Type = L7Type.Https;
        }
    }
    public class Sftp : Layer7
    {
        public Sftp()
        {
            Type = L7Type.Sftp;
        }
    }
    public class Ssh : Layer7
    {
        public Ssh()
        {
            Type = L7Type.Ssh;
        }
    }
}
