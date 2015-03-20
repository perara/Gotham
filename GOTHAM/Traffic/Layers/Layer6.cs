using System;
// ReSharper disable UnusedAutoPropertyAccessor.Global

namespace GOTHAM.Traffic.Layers
{
    // Presentation Layer

    // TODO: Change class and type\protocol to protected
    public class NoEncryption : Layer6
    {
        public NoEncryption()
        {
            Type = L6Type.None;
        }
    }

    // TODO: Change class and type\protocol to protected
    public class Ssl : Layer6
    {
        public Guid Hash { get; set; }
        public int SecVersion { get; set; }


        public Ssl(Guid hash, int version)
        {
            Type = L6Type.Ssl;

            Hash = hash;
            SecVersion = version;
        }
    }

    public class Tls : Layer6
    {
        public Guid Hash { get; set; }
        public int SecVersion { get; set; }


        public Tls(Guid hash, int version)
        {
            Type = L6Type.Tls;

            Hash = hash;
            SecVersion = version;
        }
    }

    public class Dtls : Layer6
    {
        public Guid Hash { get; set; }
        public int SecVersion { get; set; }


        public Dtls(Guid hash, int version)
        {
            Type = L6Type.Dtls;

            Hash = hash;
            SecVersion = version;
        }
    }
}
