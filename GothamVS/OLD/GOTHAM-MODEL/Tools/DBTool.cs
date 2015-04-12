﻿using GOTHAM.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace GOTHAM.Tools
{
    [Obsolete]
    public static class DbTool
    {
        private static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Writes a list of Entities to database. Example: List of NodeEntity
        /// </summary>
        /// <param name="input"></param>
        /// <param name="update"></param>
        /// <param name="batchSize"></param>
        [Obsolete]
        public static void WriteList(object input, bool update = false, int batchSize = 50)
        {
            var list = ((IList)input).Cast<object>().ToList();

            if (!(list[0] is BaseEntity))
                throw new Exception("Tried to write invalid data to database. Must be a valid entity");

            // Open up a transaction and stores data to database 
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                using (var transaction = session.BeginTransaction())
                {

                    var i = 0;
                    foreach (var item in list)
                    {

                        if (update)
                            session.Merge(item);
                        else
                            session.Save(item);

                        if (i % batchSize == 0)
                        {
                            session.Flush();
                            session.Clear();
                        }

                        // Prints persentage output each 100 entity
                        if (i++%100 != 0) continue;
                        var p = 100.0 / list.Count * i;
                        Log.Info((int)p + "%");
                    }

                    transaction.Commit();
                }// End transaction
            }// End session
        }// End function


        /// <summary>
        /// Writes a single entity to database
        /// </summary>
        /// <param name="input"></param>
        [Obsolete]
        public static void Write(BaseEntity input)
        {
            WriteList(new List<BaseEntity>() { input });
        }// End function
    }//End Class
}
