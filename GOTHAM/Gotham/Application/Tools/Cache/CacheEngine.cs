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
    public static List<Connection> Connections { get; set; }

    public static CacheObject<NodeEntity> Nodes { get; set; }
    public static CacheObject<CableEntity> Cables { get; set; }
    public static CacheObject<CablePartEntity> CableParts { get; set; }
    public static CacheObject<NodeCableEntity> NodeCables { get; set; }
    public static CacheObject<CableTypeEntity> CableTypes { get; set; }
    public static CacheObject<CountryEntity> Countries { get; set; }

    private static bool inited = false;

    public static void Init()
    {
      if (!CacheEngine.inited)
      {

        Nodes = new CacheObject<NodeEntity>(DBTool.getTable<NodeEntity>());
        Cables = new CacheObject<CableEntity>(DBTool.getTable<CableEntity>());
        CableParts = new CacheObject<CablePartEntity>(DBTool.getTable<CablePartEntity>());
        NodeCables = new CacheObject<NodeCableEntity>(DBTool.getTable<NodeCableEntity>());
        CableTypes = new CacheObject<CableTypeEntity>(DBTool.getTable<CableTypeEntity>());
        Countries = new CacheObject<CountryEntity>(DBTool.getTable<CountryEntity>());
        inited = true;
      }
    }
  }
}
