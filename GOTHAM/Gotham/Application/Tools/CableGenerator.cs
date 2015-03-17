using GOTHAM.Model;
using GOTHAM.Model.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Tools
{
    class CableGenerator
    {
        public static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Main cable generation algorithm. Iterate from left and connect to closest nodes on the right
        /// </summary>
        /// <param name="nodes"></param>
        /// <param name="siblings"></param>
        public static void GenerateCables(List<NodeEntity> nodes, int siblings)
        {
            var sortedNodes = nodes.OrderBy(o => o.lng).ToList();
            sortedNodes.Reverse();
            var newCables = new List<BaseEntity>();
            //var newCableParts = new List<BaseEntity>();


            for (int i = sortedNodes.Count - 1; i >= 0; i--)
            {

                var node = sortedNodes[i];
                sortedNodes.RemoveAt(i);

                if (node.tier.id != 1) continue;

                var cable = new CableEntity(10000, new CableTypeEntity() { id = 0 }, 0, "Land Cable");
                var cableParts = new List<CablePartEntity>();

                cable.nodes = new List<NodeEntity>();

                var nodeList = new Dictionary<double, NodeEntity>();

                //SortedDictionary<double, NodeEntity> nodeList = new SortedDictionary<double, NodeEntity>();


                foreach (var neighbor in sortedNodes)
                {
                    //Console.WriteLine("Attempting to add: " + neighbor.id + "|" + neighbor.name);
                    // Calculate Distance
                    var distance = GeoTool.GetDistance(node.GetCoordinates(), neighbor.GetCoordinates());

                    // Skip if self or same position
                    var exists = nodeList.Where(x => x.Value.lat == neighbor.lat && x.Value.lng == neighbor.lng).FirstOrDefault();
                    if (exists.Value != null || node == neighbor) continue;

                    // See if there is a "worse"/"further away" element in the dict
                    var worstElement = nodeList.Where(x => x.Key > distance && x.Value.lng > neighbor.lng).FirstOrDefault();

                    // If there is no worse element in the dict and there is still room for an sibling,
                    // Add to the list
                    if (worstElement.Value == null && nodeList.Count < siblings)
                    {
                        nodeList.Add(distance, neighbor);
                    }
                    else if (worstElement.Value != null)
                    {
                        nodeList.Remove(worstElement.Key);
                        nodeList.Add(distance, neighbor);
                    }
                }

                foreach (var sibling in nodeList)
                {
                    newCables.Add(NewCable(node, sibling.Value, 10000, sibling.Key));
                }
            }

            DBTool.WriteList(newCables);

        }


        /// <summary>
        /// Returns a new cable generated between two nodes
        /// </summary>
        /// <param name="node1"></param>
        /// <param name="node2"></param>
        /// <param name="bandwidth"></param>
        /// <param name="distance"></param>
        /// <returns></returns>
        public static CableEntity NewCable(NodeEntity node1, NodeEntity node2, long bandwidth = 10000, double distance = 0)
        {
            // Make cable and declare lists
            var cable = new CableEntity(bandwidth, new CableTypeEntity() { id = 0 }, distance, "Land Cable (" + node1.id + "," + node2.id + ")");
            cable.cableParts = new List<CablePartEntity>();
            cable.nodes = new List<NodeEntity>();

            // If cable crosses -180/180 latitude, make extra cable part
            if (Math.Abs(node1.lng - node2.lng) > 80)
            {
                log.Info("MADE EXTRA CABLE " + Math.Abs(node1.lng - node2.lng));
                // Make cable 1 start and end point
                var cableStart = new CablePartEntity(cable, 0, node1.lat, node1.lng);
                var cableEnd = new CablePartEntity(cable, 1, (node2.lat + (node1.lat - node2.lat) / 2), -180);

                // Make cable 2 start and end point
                var cableTwoStart = new CablePartEntity(cable, 0, (node2.lat + (node1.lat - node2.lat) / 2), 180);
                var cableTwoEnd = new CablePartEntity(cable, 1, node2.lat, node2.lng);

                // Add cable parts to cable
                cable.cableParts.Add(cableStart);
                cable.cableParts.Add(cableEnd);
                cable.cableParts.Add(cableTwoStart);
                cable.cableParts.Add(cableTwoEnd);
            }
            else
            {
                // Make cable start and end point
                var cableStart = new CablePartEntity(cable, 0, node1.lat, node1.lng);
                var cableEnd = new CablePartEntity(cable, 1, node2.lat, node2.lng);

                // Add cable parts to cable
                cable.cableParts.Add(cableStart);
                cable.cableParts.Add(cableEnd);
            }
            // Refference this cable in each node
            node1.cables.Add(cable);
            node2.cables.Add(cable);

            return cable;
        }

        /// <summary>
        /// Connects cable and nodes within the defined distance (ex. 5 KM, Connects cables within 5 KM of each node) and writes cables to DB
        /// </summary>
        /// <param name="maxDistance"></param>
        public static void ConnectNodes(double maxDistance)
        {
            var nodes = Globals.GetInstance().getTable<NodeEntity>();
            var cables = Globals.GetInstance().getTable<CableEntity>();
            var nodeCables = new List<string>();
            var nodeCableEntities = new List<NodeCableEntity>();

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

                            if (!nodeCables.Contains(pair.ToString()))
                            {
                                nodeCables.Add(pair.ToString());
                                nodeCableEntities.Add(Connect(cable, node));
                            }
                        }
                    }// End part
                }// End cable
            }// End node
            DBTool.WriteList(nodeCableEntities);
        }

        /// <summary>
        /// Connects the input node(current) to the closest node in list(nodes) and returns the cable generated
        /// </summary>
        /// <param name="current"></param>
        /// <param name="nodes"></param>
        /// <returns></returns>
        public static CableEntity connectClosest(NodeEntity current, List<NodeEntity> nodes)
        {
            var closest = nodes.Last();
            var closestDist = GeoTool.GetDistance(current.GetCoordinates(), closest.GetCoordinates());

            foreach (var node in nodes)
            {
                var dist = GeoTool.GetDistance(current.GetCoordinates(), node.GetCoordinates());
                if (dist < closestDist)
                {
                    closest = node;
                    closestDist = dist;
                }
            }
            return NewCable(current, closest, 10000);
        }

        /// <summary>
        /// Adds connection between defined node and cable
        /// </summary>
        /// <param name="cable"></param>
        /// <param name="node"></param>
        public static NodeCableEntity Connect(CableEntity cable, NodeEntity node)
        {

            var nodeCable = new NodeCableEntity();
            nodeCable.cable = cable;
            nodeCable.node = node;

            return nodeCable;
        }

        /// <summary>
        /// Connects the nodes in list(nodes) to eachother if the distance is less than specified(maxDist) and writes the cables to DB
        /// </summary>
        /// <param name="nodes"></param>
        /// <param name="maxDist"></param>
        public static void ConnectCloseNodes(List<NodeEntity> nodes, int maxDist)
        {
            var cableHashes = new List<string>();
            var foundDuplicate = false;

            List<CableEntity> newCables = new List<CableEntity>();
            List<CablePartEntity> newCableParts = new List<CablePartEntity>();

            foreach (var node1 in nodes)
            {
                foreach (var node2 in nodes)
                {
                    foundDuplicate = false;
                    var dist = GeoTool.GetDistance(node1.GetCoordinates(), node2.GetCoordinates());

                    // Check if cable should be made
                    if (node1 == node2 || node1.siblings.Contains(node2) || dist > maxDist || node1.siblings.Count() > 2 || node2.siblings.Count() > 2) continue;

                    // Make cable
                    var cable = new CableEntity(0, new CableTypeEntity() { id = 0 }, 0, "Mini Cable");
                    cable.cableParts = new List<CablePartEntity>();
                    cable.nodes = new List<NodeEntity>();

                    // Make cableparts
                    var cablePart1 = new CablePartEntity(cable, 0, node1.lat, node1.lng);
                    var cablePart2 = new CablePartEntity(cable, 1, node2.lat, node2.lng);

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
                    newCables.Add(cable);
                    //newCableParts.Add(cablePart1);
                    //newCableParts.Add(cablePart2);

                    // Add to newCables list to prevent duplicate cables
                    cableHashes.Add(hash1);
                    if (newCables.Count() % 1000 == 0)
                        Console.WriteLine(newCables.Count + " Cables");
                }
            }

            log.Info("Press enter to add cables to database");
            Console.ReadLine();


            DBTool.WriteList(newCables);
            DBTool.WriteList(newCableParts);
        }


        /// <summary>
        /// Connects all sea nodes to the closest land node and writes the cables to DB
        /// </summary>
        public static void ConnectSeaNodesToLand()
        {
            var landNodes = Globals.GetInstance().nodes.Where(x => x.tier.id == 1).ToList();
            var seaNodes = Globals.GetInstance().nodes.Where(x => x.tier.id == 4).ToList();
            var newCables = new List<CableEntity>();

            foreach (var seaNode in seaNodes)
            {
                newCables.Add(connectClosest(seaNode, landNodes));
            }

            DBTool.WriteList(newCables);
        }
    }
}
