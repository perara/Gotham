using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Model.Tools
{
    public class DBTool
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // Store multiple entities to database
        public static void WriteList(List<BaseEntity> input, int batchSize = 20)
        {
            // Open up a transaction and stores data to database 
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {
                    for (int i = 0; i < input.Count; i++)
                    {
                        session.Save(input[i]);
                        if (i % batchSize == 0)
                        {
                            session.Flush();
                            session.Clear();
                        }

                        // Prints persentage output each 100 entity
                        if (i % 100 == 0)
                        {
                            double p = 100.0 / input.Count * i;
                            log.Info((int)p + "%");
                        }
                    }
                    transaction.Commit();
                }// End transaction
            }// End session
        }// End function


        // Store single entity to database
        public static void Write(BaseEntity input)
        {

            // TODO: Deprecated?
            // Check if input is valid
            if (input.GetType().Namespace != "GOTHAM.Model")
            {
                return;
            }

            // Open up a transaction and stores data to database
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {
                    session.Save(input);
                    transaction.Commit();
                }// End transaction
            }// End session
        }// End function
    }//End Class
}
