using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Tools.Cache
{
  public class CacheEngine
  {
    public static CacheObject<NodeEntity> Nodes { get; set; }
    public static CacheObject<CableEntity> Cables { get; set; }


    private static bool inited = false;

    public static void Init()
    {
      if (!CacheEngine.inited)
      {

        Nodes = new CacheObject<NodeEntity>(Globals.GetInstance().getTable<NodeEntity>());
        Cables = new CacheObject<CableEntity>(Globals.GetInstance().getTable<CableEntity>());
        inited = true;
      }
    }


  }
}
