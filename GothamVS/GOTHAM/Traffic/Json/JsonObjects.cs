// ReSharper disable UnusedAutoPropertyAccessor.Global
namespace GOTHAM.Traffic.Json
{
    public class NodeJson
    {
        public string Country { get; set; }
        public string Name { get; set; }
        public Coordinates Coordinates { get; set; }

    }
    public class Coordinates
    {
        public string Latitude { get; set; }
        public string Longitude { get; set; }
    }
}
