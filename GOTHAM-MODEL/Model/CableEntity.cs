
namespace GOTHAM.Model
{
    public class CableEntity
    {

        // TODO: Coordinates for physical location of cable, not only linear

        public virtual int id { get; set; }
        public virtual NodeEntity node1 { get; set; }
        public virtual NodeEntity node2 { get; set; }
        public virtual int priority { get; set; }
        public virtual long bandwidth { get; set; }
        public virtual double length { get; set; }
        public virtual CableTypeEntity type { get; set; }
        public virtual double quality { get; set; }
    }
}
