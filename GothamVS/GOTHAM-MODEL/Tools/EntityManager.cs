using System;
using System.IO;
using System.Linq;
using FluentNHibernate;
using FluentNHibernate.Cfg;
using FluentNHibernate.Cfg.Db;
using FluentNHibernate.Mapping;
using FluentNHibernate.Mapping.Providers;
using GOTHAM.Model;
using Newtonsoft.Json.Linq;
using NHibernate;
using NHibernate.Caches.SysCache;

namespace GOTHAM.Tools
{
    public class EntityManager
    {
        private static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private static readonly EntityManager Instance = new EntityManager();
        private ISessionFactory SessionFactory { get; set; }

        public static ISessionFactory GetSessionFactory()
        {
            return Instance.SessionFactory;
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
            var machineName = Environment.MachineName;
            if (machineName.Equals("GRAV"))
            {
                sqlConfig = configuration["mysql"]["local"];
                Log.Info("Using SQL Configuration: Paul");
            }
            else if (machineName.Equals("PER-ARNE"))
            {
                //sqlConfig = configuration["mysql"]["production"];
                sqlConfig = configuration["mysql"]["per"];
                Log.Info("Using SQL Configuration: Per");
            }
            else
            {
                sqlConfig = configuration["mysql"]["production"];
                Log.Info("Using SQL Configuration: Default");
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


                /*hibernateConfig.ExposeConfiguration(c =>
                {
                    c.SetProperty("current_session_context_class", "web");
                    c.SetProperty("cache.provider_class", "NHibernate.Caches.SysCache.SysCacheProvider, NHibernate.Caches.SysCache");
                    c.SetProperty("cache.use_second_level_cache", "true");
                    c.SetProperty("cache.use_query_cache", "true");
                    c.SetProperty("expiration", "86400");
                });*/


                //hibernateConfig.Cache(c => c.UseQueryCache().UseSecondLevelCache().ProviderClass<SysCacheProvider>());
 


              

                // Generate Session Factory
                SessionFactory = hibernateConfig.BuildSessionFactory();

               
            }
            catch (Exception)
            {
                Log.Error("Error in Database Configuration");
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
            var ns = typeof(T).Namespace;
            var types = typeof(T).Assembly.GetExportedTypes()
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
