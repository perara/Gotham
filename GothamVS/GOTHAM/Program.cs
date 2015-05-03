using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using Gotham.Application.Generators;
using Gotham.Application.GUI;
using Gotham.Application.Parsers;
using Gotham.Gotham.Generators;
using Gotham.Model;
using GOTHAM.Repository.Abstract;


namespace Gotham
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {

            //ConsistencyFixer.GetInstance().ConnectSeaCables();
            //TxtParse.ParseGregNodes(@"C:\temp\seaLandings.txt");;
            //CableGenerator.ConnectNodesToCables(1);
            //NodeGenerator.FixNodeCountries();
            //NodeNetworkGenerator.Generate();

            System.Windows.Forms.Application.EnableVisualStyles();
            System.Windows.Forms.Application.SetCompatibleTextRenderingDefault(false);
            System.Windows.Forms.Application.Run(new Form1());
        }
    }
}
