using System;
using GOTHAM.Gotham.Application.Tools;
using GOTHAM.Model;
using GOTHAM.Gotham.API;

namespace GOTHAM
{
    class Program
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);


        static void Main(string[] args)
        {
            //
            // LOG4NET configuration
            //
            log4net.Config.XmlConfigurator.Configure();

            //
            // ServiceStack API Server
            //
            ServiceStackConsoleHost.Start();


            var locations = TxtParse.FromFile("C:\\temp\\worldcitiespop.txt");

            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {
                    for (int i = 0; i < locations.Count; i++)
                    {
                        session.Save(locations[i]);
                        if (i % 20 == 0)
                        {
                            session.Flush();
                            session.Clear();
                            
                        }

                        if (i % 10000 == 0)
                        {
                            double p = 0.0000315059861373660995589161940768746061 * i;
                            log.Info((int)p + "%");
                        }
                    }
                    transaction.Commit();
                }// End transaction
            }// End session
        }// End Main
    }// End Class
}
