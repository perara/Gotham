﻿using GOTHAM.Model;
using GOTHAM.Model.Tools;
using NHibernate;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Tools
{
    public class DBTool
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Writes a list of Entities to database. Example: List of NodeEntity
        /// </summary>
        /// <param name="input"></param>
        /// <param name="batchSize"></param>
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
                        if (i++ % 100 != 0) continue;
                        log.Info((int)(100.0 / list.Count * i) + " %");
                    }
                    transaction.Commit();
                }// End transaction
            }// End session
        }// End function


        /// <summary>
        /// Writes a single entity to database
        /// </summary>
        /// <param name="input"></param>
        public static void Write(BaseEntity input)
        {
            // Check if input is valid
            if (input.GetType().Namespace != "GOTHAM.Model")
            {
                throw new Exception("Object is not a part of the GOTHAM.Model namespace");
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

        /// <summary>
        /// Gets a list of all entities in a table
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static List<T> getTable<T>()
        {
            // SELECT * FROM X
            // SELECT * FROM X where Y = Z and Z = KUK

            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {

                Type typeParameterType = typeof(T);
                var data = session

                    .CreateCriteria(typeParameterType)
                    .SetCacheable(true)
                    .SetCacheMode(CacheMode.Normal)
                    .List<T>()
                    .ToList();
                return data;
            }
        }
    }//End Class
}
