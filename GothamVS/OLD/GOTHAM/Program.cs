using System;
using System.Runtime.InteropServices;
using Gotham.Application.GUI;
using GOTHAM.Model;
using GOTHAM.Tools;
using NHibernate.Linq;

namespace Gotham
{
    static class Program
    {

        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool AllocConsole();

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            AllocConsole();

            //
            // Configure Log4Net
            // 
            log4net.Config.XmlConfigurator.Configure();

            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                var start = DateTime.Now;
                session.Query<CableEntity>();
                var end = DateTime.Now - start;
                Console.WriteLine(end.TotalMilliseconds);
            }
            
            
            // Start GUI
            System.Windows.Forms.Application.EnableVisualStyles();
            System.Windows.Forms.Application.SetCompatibleTextRenderingDefault(false);
            System.Windows.Forms.Application.Run(new Form1());


        }
    }
}
