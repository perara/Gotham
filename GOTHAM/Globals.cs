using System;
using System.Collections.Generic;
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




        int idCounter;



        public int GetID()
        {
            int id = idCounter;
            idCounter++;
            return id;
        }
    }
}
