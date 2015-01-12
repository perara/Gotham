using System;
using System.IO;
using System.Reflection;
using FluentNHibernate.Automapping;
using FluentNHibernate.Cfg;
using FluentNHibernate.Cfg.Db;
using FluentNHibernate.Data;
using IronPython.Runtime.Exceptions;
using Newtonsoft.Json.Linq;
using NHibernate;

namespace GOTHAM.Gotham.Application
{
  class EntityManager
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

      JObject configuration = JObject.Parse(File.ReadAllText(@"Configuration.json"));
      JToken sqlConfig;

      // Determine which Configuration file to use
      var MachineName = Environment.MachineName;
      if (MachineName.Equals("GRAV"))
      {
        sqlConfig = configuration["mysql"]["paul"];
        log.Info("Using SQL Configuration: Paul");
      }
      else if (MachineName.Equals("PER-ARNE-PC"))
      {
        sqlConfig = configuration["mysql"]["per"];
        log.Error("Using SQL Configuration: Per");
      }
      else
      {
        throw new RuntimeException("There is no configurationfile for this host");
      }


      SessionFactory = Fluently.Configure()
        .Database(MySQLConfiguration
          .Standard
          .ConnectionString(cs => cs.Server(sqlConfig["host"].ToString())
            .Database(sqlConfig["database"].ToString())
            .Username(sqlConfig["username"].ToString())
            .Password(sqlConfig["password"].ToString())
          ))
        .Mappings(
          m => m.AutoMappings.Add(
               AutoMap.AssemblyOf<Entity>()
               .Where(t => t.Namespace == "GOTHAM.Gotham.Application.Model"))
        ).BuildSessionFactory();

    }







  }
}
