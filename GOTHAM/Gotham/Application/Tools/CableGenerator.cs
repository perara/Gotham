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

            //cable.Node1 = current;
            //cable.Node2 = closenode;
            cable.distance = closest;
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

            //cable.Node1 = node1;
            //cable.Node2 = node2;
            cable.capacity = bandwidth;
            cable.type = new CableTypeEntity() { id = 0 };

            // Refference this cable in each node
            node1.cables.Add(cable);
            node2.cables.Add(cable);

            return cable;
        }

        /// <summary>
        /// Connects cable and nodes within the defined distance (ex. 5 KM, Connects cables within 5 KM of each node)
        /// </summary>
        /// <param name="maxDistance"></param>
        public static void ConnectNodes(double maxDistance)
        {
            var nodes = Globals.GetInstance().getTable<NodeEntity>();
            var cables = Globals.GetInstance().getTable<CableEntity>();
            var nodecables = new List<string>();

            foreach (var node in nodes)
            {
                foreach (var cable in cables)
                {
                    foreach (var part in cable.cableParts)
                    {
                        var nodePos = new Coordinate.LatLng(node.lat, node.lng);
                        var partPos = new Coordinate.LatLng(part.lat, part.lng);

                        var dist = GeoTool.GetDistance(nodePos, partPos);

                        if (dist < maxDistance)
                        {
                            var pair = new KeyValuePair<int, int>(node.id, cable.id);

                            if(!nodecables.Contains(pair.ToString()))
                            {
                                nodecables.Add(pair.ToString());
                                Connect(cable, node);
                            }
                        }
                    }// End part
                }// End cable
            }// End node
        }

        /// <summary>
        /// Adds connection between defined node and cable
        /// </summary>
        /// <param name="cable"></param>
        /// <param name="node"></param>
        public static void Connect(CableEntity cable, NodeEntity node)
        {

            var nodeCable = new NodeCableEntity();
            nodeCable.cable = cable;
            nodeCable.node = node;

            DBTool.Write(nodeCable);
        }

        public static void ConnectCloseNodes(List<NodeEntity> nodes, int maxDist)
        {
            var cableHashes = new List<string>();
            var foundDuplicate = false;

            foreach (var node1 in nodes)
            {
                foreach (var node2 in nodes)
                {
                    foundDuplicate = false;
                    var dist = GeoTool.GetDistance(node1.GetCoordinates(), node2.GetCoordinates());

                    // Check if cable should be made
                    if (node1 == node2 || node1.siblings.Contains(node2) || dist > maxDist) continue;
                    
                    // Make cable
                    var cable = new CableEntity();
                    cable.cableParts = new List<CablePartEntity>();
                    cable.nodes = new List<NodeEntity>();
                    cable.name = "Mini Cable";
                    cable.type = new CableTypeEntity() { id = 0 };
                    cable.year = 0;

                    // Make cableparts
                    var cablePart1 = new CablePartEntity();
                    var cablePart2 = new CablePartEntity();
                    cablePart1.cable = cable;
                    cablePart1.number = 0;
                    cablePart1.lat = node1.lat;
                    cablePart1.lng = node1.lng;
                    cablePart2.cable = cable;
                    cablePart2.number = 1;
                    cablePart2.lat = node2.lat;
                    cablePart2.lng = node2.lng;

                    cable.cableParts.Add(cablePart1);
                    cable.cableParts.Add(cablePart2);

                    cable.nodes.Add(node1);
                    cable.nodes.Add(node2);

                    var coord1 = Coordinate.newLatLng(node1.lat, node1.lng);
                    var coord2 = Coordinate.newLatLng(node2.lat, node2.lng);

                    var hash1 = (coord1.lat + coord1.lng + coord2.lat + coord2.lng).ToString();

                    // Check if cable is already made
                    foreach (var cableHash in cableHashes)
                    {
                        if (cableHash == hash1)
                        {
                            foundDuplicate = true;
                            break;
                        }
                    }

                    // Continue if cable is already made
                    if (foundDuplicate) continue;
                    
                    // Write to database
                    DBTool.Write(cable);
                    DBTool.Write(cablePart1);
                    DBTool.Write(cablePart2);

                    // Add to newCables list to prevent duplicate cables
                    cableHashes.Add(hash1);
                    Console.WriteLine("Made new cable");
                }                
            }
        }
    }
}
