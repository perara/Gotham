using FluentNHibernate.Mapping;
using GOTHAM.Model.Tools;
using GOTHAM.Tools;
using NHibernate.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class PersonEntity : BaseEntity
    {
        // Personal information
        public virtual string Gender { get; set; }
        public virtual string Givenname { get; set; }
        public virtual string Surname { get; set; }
        public virtual string Address { get; set; }
        public virtual string City { get; set; }
        public virtual string CountryCode { get; set; }
        public virtual string Email { get; set; }
        public virtual string Username { get; set; }
        public virtual string Password { get; set; }
        public virtual int Telephone { get; set; }
        public virtual int CcNumber { get; set; }
        public virtual string Occupation { get; set; }
        public virtual string Company { get; set; }
        public virtual string Vehicle { get; set; }

        // Location
        public virtual double Lat { get; set; }
        public virtual double Lng { get; set; }

        /// <summary>
        /// Default constructor
        /// </summary>
        protected PersonEntity() { }

        /// <summary>
        /// "Empty" constructor
        /// </summary>
        /// <param name="country"></param>
        public PersonEntity(string country = "*")
        {
            
        }
        public virtual Coordinate.LatLng GetCoords()
        {
            return new Coordinate.LatLng(Lat, Lng);
        }
    }
    public class PersonEntityMap : ClassMap<PersonEntity>
    {

        public PersonEntityMap()
        {
            Table("person");
            Id(x => x.Id).GeneratedBy.Identity();
            Map(x => x.Gender).Not.Nullable();
            Map(x => x.Givenname).Not.Nullable();
            Map(x => x.Surname).Not.Nullable();
            Map(x => x.Address).Not.Nullable();
            Map(x => x.City).Not.Nullable();
            Map(x => x.CountryCode).Not.Nullable();
            Map(x => x.Email).Not.Nullable();
            Map(x => x.Username).Not.Nullable();
            Map(x => x.Password).Not.Nullable();
            Map(x => x.Telephone).Not.Nullable();
            Map(x => x.CcNumber).Not.Nullable();
            Map(x => x.Occupation).Not.Nullable();
            Map(x => x.Company).Not.Nullable();
            Map(x => x.Vehicle).Not.Nullable();

            Map(x => x.Lat).Not.Nullable();
            Map(x => x.Lng).Not.Nullable();

            Map(x => x.Random).Formula("RAND()");
        }
    }
}
