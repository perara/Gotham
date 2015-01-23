using GOTHAM.Model;
using GOTHAM.Model.Tools;
using GOTHAM.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Application.Tools
{
    class CableGenerator
    {
        public static List<CableEntity> MakeCables(NodeEntity current, List<NodeEntity> nodes)
        {
            var cables = new List<CableEntity>();
            NodeEntity closenode = null;
            double closest = Double.MaxValue;

            // TODO Change to A* algorithm
            foreach (var l1 in nodes)
            {
                foreach (var l2 in l1.siblings)
                {
                    foreach (var l3 in l2.siblings)
                    {
                        foreach (var l4 in l3.siblings)
                        {
                            foreach (var l5 in l4.siblings)
                            {
                                if (!l5.siblings.Contains(current))
                                {
                                    double dist = GeoTool.GetDistance(current.GetCoordinates(), l1.GetCoordinates());
                                    if (closest > dist && dist != 0.0 && !l1.siblings.Contains(current))
                                    {
                                        closest = dist;
                                        closenode = l1;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            var cable = new CableEntity();
            var type = new CableTypeEntity() { id = 0 };

            cable.node1 = current;
            cable.node2 = closenode;
            cable.length = closest;
            cable.type = type;
            cables.Add(cable);
            current.siblings.Add(closenode);

            return cables;
        }

        // Make new cables
        // TODO Get relevant data
        public static CableEntity NewCable(NodeEntity node1, NodeEntity node2, long bandwidth)
        {
            var cable = new CableEntity();

            cable.node1 = node1;
            cable.node2 = node2;
            cable.bandwidth = bandwidth;
            //cable.priority = 1;
            cable.quality = 2;
            cable.type = new CableTypeEntity() { id = 0 };

            // Refference this cable in each node
            node1.cables.Add(cable);
            node2.cables.Add(cable);

            return cable;
        }
    }
}
