﻿using System;
using GOTHAM.Model;
using GOTHAM.Traffic;
using System.Collections.Generic;
using System.Linq;
using GOTHAM.Model.Tools;
using NHibernate;
using NHibernate.Linq;

namespace GOTHAM.Tools.Cache
{
    public class CacheEngine
    {
        public static List<Connection> Connections { get; set; }

        public static CacheObject<NodeEntity> Nodes { get; set; }
        public static CacheObject<CableEntity> Cables { get; set; }
        public static CacheObject<CablePartEntity> CableParts { get; set; }
        public static CacheObject<NodeCableEntity> NodeCables { get; set; }
        public static CacheObject<CableTypeEntity> CableTypes { get; set; }
        public static CacheObject<CountryEntity> Countries { get; set; }

        private static bool _inited;

        public static void Init()
        {
            if (_inited) return;

            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                Nodes = new CacheObject<NodeEntity>(session
                        .CreateCriteria(typeof(NodeEntity))
                        .SetCacheable(true)
                        .SetCacheMode(CacheMode.Normal)
                        .List<NodeEntity>()
                        .ToList());

                Cables = new CacheObject<CableEntity>(session
                            .CreateCriteria(typeof(CableEntity))
                            .SetCacheable(true)
                            .SetCacheMode(CacheMode.Normal)
                            .List<CableEntity>()
                            .ToList());

                CableParts = new CacheObject<CablePartEntity>(session
                            .CreateCriteria(typeof(CablePartEntity))
                            .SetCacheable(true)
                            .SetCacheMode(CacheMode.Normal)
                            .List<CablePartEntity>()
                            .ToList());

                NodeCables = new CacheObject<NodeCableEntity>(session
                            .CreateCriteria(typeof(NodeCableEntity))
                            .SetCacheable(true)
                            .SetCacheMode(CacheMode.Normal)
                            .List<NodeCableEntity>()
                            .ToList());

                CableTypes = new CacheObject<CableTypeEntity>(session
                            .CreateCriteria(typeof(CableTypeEntity))
                            .SetCacheable(true)
                            .SetCacheMode(CacheMode.Normal)
                            .List<CableTypeEntity>()
                            .ToList());

                Countries = new CacheObject<CountryEntity>(session
                            .CreateCriteria(typeof(CountryEntity))
                            .SetCacheable(true)
                            .SetCacheMode(CacheMode.Normal)
                            .List<CountryEntity>()
                            .ToList());

                _inited = true;
            }
        }
    }
}
