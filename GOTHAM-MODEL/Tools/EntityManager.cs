using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using FluentNHibernate;
using FluentNHibernate.Automapping;
using FluentNHibernate.Cfg;
using FluentNHibernate.Cfg.Db;
using FluentNHibernate.Data;
using FluentNHibernate.Mapping;
using FluentNHibernate.Mapping.Providers;
using Newtonsoft.Json.Linq;
using NHibernate;
using NHibernate.Caches.SysCache;

namespace GOTHAM.Model.Tools
{
    public class EntityManager
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger
        (System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private static EntityManager INSTANCE = new EntityManager();
        private ISessionFactory SessionFactory { get; set; }

        public static ISessionFactory GetSessionFactory()
        {
            return INSTANCE.SessionFactory;
        }

        private EntityManager()
        {
            InitializeSessionFactory();
        }

        private void InitializeSessionFactory()
        {

            JObject configuration = JObject.Parse(File.ReadAllText("./Tools/Configuration.json"));
            JToken sqlConfig;

            // Determine which Configuration file to use
            var MachineName = Environment.MachineName;
            if (MachineName.Equals("GRAV"))
            {
                sqlConfig = configuration["mysql"]["local"];
                log.Info("Using SQL Configuration: Paul");
            }
            else if (MachineName.Equals("PER-ARNE"))
            {
                //sqlConfig = configuration["mysql"]["production"];
                sqlConfig = configuration["mysql"]["per"];
                log.Info("Using SQL Configuration: Per");
            }
            else
            {
                sqlConfig = configuration["mysql"]["production"];
                log.Info("Using SQL Configuration: Default");
                //throw new Exception("There is no configurationfile for this host");

            }



            try
            {
                // Create Hibernate Configuration
                var hibernateConfig = Fluently.Configure();


                // Set Database
                hibernateConfig.Database(MySQLConfiguration
                  .Standard
                  .ConnectionString(cs => cs.Server(sqlConfig["host"].ToString())
                    .Database(sqlConfig["database"].ToString())
                    .Username(sqlConfig["username"].ToString())
                    .Password(sqlConfig["password"].ToString())
                  ));

                // Set Mappings
                hibernateConfig.Mappings(m => m.FluentMappings.AddFromNamespaceOf<NodeEntity>());

                // Configure Cache
                hibernateConfig.Cache(c => c.UseQueryCache()
                .UseSecondLevelCache()
                .ProviderClass<NHibernate.Cache.HashtableCacheProvider>());
            

                // Generate Session Factory
                SessionFactory = hibernateConfig.BuildSessionFactory();

            }
            catch (Exception e)
            {
                
                log.Error("Error in Database Configuration");
                throw;
            }
        }
    }

    /// <summary>
    /// http://stackoverflow.com/questions/6204511/how-to-add-mappings-by-namespace-in-fluent-nhibernate
    /// </summary>
    public static class FluentNHibernateExtensions
    {
        public static FluentMappingsContainer AddFromNamespaceOf<T>(
            this FluentMappingsContainer fmc)
        {
            string ns = typeof(T).Namespace;
            IEnumerable<Type> types = typeof(T).Assembly.GetExportedTypes()
                .Where(t => t.Namespace == ns)
                .Where(x => IsMappingOf<IMappingProvider>(x) ||
                            IsMappingOf<IIndeterminateSubclassMappingProvider>(x) ||
                            IsMappingOf<IExternalComponentMappingProvider>(x) ||
                            IsMappingOf<IFilterDefinition>(x));

            foreach (Type t in types)
            {
                fmc.Add(t);
            }

            return fmc;
        }

        /// <summary>
        /// Private helper method cribbed from FNH source (PersistenModel.cs:151)
        /// </summary>
        private static bool IsMappingOf<T>(Type type)
        {
            return !type.IsGenericType && typeof(T).IsAssignableFrom(type);
        }
    }

}
