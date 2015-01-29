﻿using FluentNHibernate.Mapping;
using GOTHAM.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model
{
    public class NodeEntity : BaseEntity
    {

        public virtual string name { get; set; }
        public virtual string country { get; set; }
        public virtual TierEntity tier { get; set; }
        public virtual int priority { get; set; }
        public virtual double bandwidth { get; set; }
        public virtual double lat { get; set; }
        public virtual double lng { get; set; }

        /// <summary>
        /// neighbors node, This can only be a node within the same Tier level
        /// </summary>
        public virtual IList<NodeEntity> siblings { get; set; }
        public virtual IList<CableEntity> cables { get; set; }

        //[Transient]
        public virtual bool isMatch(NodeEntity node)
        {
            var lat = node.lat == this.lat ? true : false;
            var lng = node.lng == this.lng ? true : false;
            return lat && lng;
        }
        public virtual Coordinate.LatLng GetCoordinates()
        {
            return new Coordinate.LatLng(lat, lng);
        }
        public virtual void getSiblings()
        {
            siblings = new List<NodeEntity>();
            foreach (var cable in cables)
            {
                foreach (var node in cable.nodes)
                {
                    if (this != node)
                    {
                        siblings.Add(node);
                    }
                }
            }
        }
    }

    public class NodeEntityMap : ClassMap<NodeEntity>
    {

        public NodeEntityMap()
        {
            Table("node");

            Id(x => x.id).Column("id").GeneratedBy.Identity();
            Map(x => x.name).Not.Nullable();
            Map(x => x.country).Not.Nullable();
            Map(x => x.bandwidth).Not.Nullable();
            Map(x => x.lat).Not.Nullable();
            Map(x => x.lng).Not.Nullable();

            //HasOne(x => x.tier);
            References(x => x.tier).Not.Nullable().Column("tier");

            HasManyToMany(x => x.cables)
                .Cascade.All()
                .Table("node_cable")
                .ParentKeyColumn("node")
                .ChildKeyColumn("cable")
                .Not.LazyLoad();

            // TODO: Check connected cables, then check nodes connected to those cables. Add to siblings list


            //HasManyToMany(x => x.cables)
            //   .Table("node_cable")
            //   .ParentKeyColumn("cable")
            //   .ChildKeyColumn("cable")
            //   .Cascade.All();


        }

    }
}
