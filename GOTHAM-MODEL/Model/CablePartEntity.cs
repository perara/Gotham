using System.Diagnostics.CodeAnalysis;
using FluentNHibernate.Mapping;
using Newtonsoft.Json;
using GOTHAM_TOOLS;

namespace GOTHAM.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class CablePartEntity : BaseEntity
    {

        [JsonIgnore]
        public virtual CableEntity Cable { get; set; }
        public virtual int Number { get; set; }
        public virtual double Lat { get; set; }
        public virtual double Lng { get; set; }
        protected CablePartEntity() { }
        public CablePartEntity(CableEntity cable, int number, double lat, double lng)
        {
            Cable = cable;
            Number = number;
            Lat = lat;
            Lng = lng;
        }
        public virtual Coordinate.LatLng GetCoords()
        {
            return new Coordinate.LatLng(Lat, Lng);
        }
    }

    public class CablePartEntityMap : ClassMap<CablePartEntity>
    {
        public CablePartEntityMap()
        {
            Table("cable_part");

            Id(x => x.Id).GeneratedBy.Identity();

            Map(x => x.Number);
            Map(x => x.Lat);
            Map(x => x.Lng);
    
            References(x => x.Cable)
                .Not.Nullable()
                .Column("cable");

        }
    }
}
