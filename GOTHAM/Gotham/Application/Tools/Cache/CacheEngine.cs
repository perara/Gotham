using GOTHAM.Model;
using GOTHAM.Traffic;
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
    public static List<Connection> Connections { get; set; }


    private static bool inited = false;

    public static void Init()
    {
      if (!CacheEngine.inited)
      {

        Nodes = new CacheObject<NodeEntity>(DBTool.getTable<NodeEntity>());
        Cables = new CacheObject<CableEntity>(DBTool.getTable<CableEntity>());
        inited = true;
      }
    }


  }
}
