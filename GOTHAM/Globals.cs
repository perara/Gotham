using GOTHAM.Gotham.Application.Model;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM
{
    public class Globals
    {
        private static Globals INSTANCE = new Globals();
        public static Globals GetInstance()
        {
            return INSTANCE;
        }
        private Globals()
        {
            // TODO: Hent fra database
            idCounter = 0;
        }



        // Global variables and objects
        public int idCounter;
        public Point mapMax = new Point(1000, 1000);

        public List<NodeEntity> rootNodes = new List<NodeEntity>();
        public List<CableEntity> cables = new List<CableEntity>();

        public int GetID()
        {
            int id = idCounter;
            idCounter++;
            return id;
        }
    }
}
