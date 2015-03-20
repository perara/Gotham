using GOTHAM.Model;
using GOTHAM.Tools.Cache;
using System;
using System.Collections.Generic;
using System.Linq;

namespace GOTHAM.Tools
{
    class CableGenerator
    {
        public static readonly log4net.ILog Log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Main cable generation algorithm. Iterate from left and connect to closest nodes on the right
        /// </summary>
        /// <param name="nodes"></param>
        /// <param name="minSiblings"></param>
        /// <param name="maxSiblings"></param>
        /// <param name="maxDistance"></param>
        public static void GenerateCables(List<NodeEntity> nodes, int minSiblings, int maxSiblings, int maxDistance = Int32.MaxValue)
        {
            Log.Info("Making land cables between land nodes with " + minSiblings + "(min) to " + maxSiblings + "(max) siblings");

            var sortedNodes = nodes.OrderBy(o => o.Lng).ToList();
            sortedNodes.Reverse();
            var newCables = new List<BaseEntity>();
            var rnd = new Random();


            for (var i = sortedNodes.Count - 1; i >= 0; i--)
            {
                var siblings = rnd.Next(minSiblings, maxSiblings);
                var node = sortedNodes[i];
                sortedNodes.RemoveAt(i);

                if (node.Tier.Id != 1) continue;

                var nodeList = new Dictionary<double, NodeEntity>();

                foreach (var neighbor in sortedNodes)
                {
                    //Console.WriteLine("Attempting to add: " + neighbor.id + "|" + neighbor.name);
                    // Calculate Distance
                    var distance = GeoTool.GetDistance(node.GetCoords(), neighbor.GetCoords());

                    // Skip if distance is greater than maxDistance
                    if (distance > maxDistance) continue;

                    // Skip if self or same position
                    var exists = nodeList.FirstOrDefault(x => x.Value.Lat.Equals(neighbor.Lat) && x.Value.Lng.Equals(neighbor.Lng));
                    if (exists.Value != null || node == neighbor) continue;

                    // See if there is a "worse"/"further away" element in the dict
                    var worstElement = nodeList.FirstOrDefault(x => x.Key > distance && x.Value.Lng > neighbor.Lng);

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

                nodeList.ToList()
                    .ForEach(x => newCables.Add(NewCable(node, x.Value, 10000, x.Key)));

            }
            DBTool.WriteList(newCables);
            Log.Info("Made " + newCables.Count + " new node to node connections");
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
            // Make cable, get type and declare lists
            var cableType = CacheEngine.CableTypes.FirstOrDefault();

            var cable = new CableEntity(bandwidth, cableType, distance, "Land Cable (" + node1.Id + "," + node2.Id + ")")
            {
                CableParts = new List<CablePartEntity>(),
                Nodes = new List<NodeEntity>(),
                Distance = 0
            };


            // If cable crosses -180/180 latitude, make extra cable part
            if (Math.Abs(node1.Lng - node2.Lng) > 80)
            {
                var toLeft = (node1.Lng < 0) ? 180 : -180;

                // Make cable 1 start and end point
                var cableStart = new CablePartEntity(cable, 0, node1.Lat, node1.Lng);
                var cableEnd = new CablePartEntity(cable, 1, (node2.Lat + (node1.Lat - node2.Lat) / 2), toLeft * -1);
                cable.Distance += GeoTool.GetDistance(cableStart.GetCoords(), cableEnd.GetCoords());

                // Make cable 2 start and end point
                var cableTwoStart = new CablePartEntity(cable, 0, (node2.Lat + (node1.Lat - node2.Lat) / 2), toLeft);
                var cableTwoEnd = new CablePartEntity(cable, 1, node2.Lat, node2.Lng);
                cable.Distance += GeoTool.GetDistance(cableTwoStart.GetCoords(), cableTwoEnd.GetCoords());

                // Add cable parts to cable
                cable.CableParts.Add(cableStart);
                cable.CableParts.Add(cableEnd);
                cable.CableParts.Add(cableTwoStart);
                cable.CableParts.Add(cableTwoEnd);
            }
            else
            {
                // Make cable start and end point
                var cableStart = new CablePartEntity(cable, 0, node1.Lat, node1.Lng);
                var cableEnd = new CablePartEntity(cable, 1, node2.Lat, node2.Lng);
                cable.Distance += GeoTool.GetDistance(cableStart.GetCoords(), cableEnd.GetCoords());

                // Add cable parts to cable
                cable.CableParts.Add(cableStart);
                cable.CableParts.Add(cableEnd);
            }
            // Refference this cable in each node
            node1.Cables.Add(cable);
            node2.Cables.Add(cable);

            return cable;
        }

        /// <summary>
        /// Connects cable and nodes within the defined distance (ex. 5 KM, Connects cables within 5 KM of each node) and writes cables to DB
        /// </summary>
        /// <param name="maxDistance"></param>
        public static void ConnectNodesToCables(int maxDistance = 50)
        {
            Log.Info("Connecting cables to nodes closer than " + maxDistance + " Kilometers");

            var nodes = CacheEngine.Nodes;
            var cableParts = CacheEngine.CableParts;
            var nodeCables = CacheEngine.NodeCables;
            var newNodeCables = new List<string>();
            var nodeCableEntities = new List<NodeCableEntity>();

            foreach (var node in nodes)
            {
                foreach (var part in cableParts)
                {
                    var dist = GeoTool.GetDistance(node.GetCoords(), part.GetCoords());
                    if (dist > maxDistance) continue;

                    var exists = nodeCables.Any(x => x.Cable.Id == part.Cable.Id && x.Node.Id == node.Id);
                    if (exists) continue;

                    var pair = new KeyValuePair<int, int>(node.Id, part.Cable.Id);
                    if (newNodeCables.Contains(pair.ToString())) continue;

                    newNodeCables.Add(pair.ToString());
                    nodeCableEntities.Add(Connect(part.Cable, node));


                }// End part
            }// End node
            DBTool.WriteList(nodeCableEntities);
            Log.Info("Made " + nodeCableEntities.Count + " node to cable connections");
        }

        /// <summary>
        /// Returns the closest node in list(nodes)
        /// </summary>
        /// <param name="current"></param>
        /// <param name="nodes"></param>
        /// <param name="maxDistance"></param>
        /// <returns></returns>
        public static NodeEntity GetClosestNode(NodeEntity current, List<NodeEntity> nodes, int maxDistance = Int32.MaxValue)
        {
            var closest = nodes.Last();
            var closestDist = GeoTool.GetDistance(current.GetCoords(), closest.GetCoords());

            foreach (var node in nodes)
            {
                var dist = GeoTool.GetDistance(current.GetCoords(), node.GetCoords());
                if (dist > closestDist) continue;

                closest = node;
                closestDist = dist;
            }

            return (closestDist > maxDistance) ? null : closest;
        }

        /// <summary>
        /// Returns the closest node in list(nodes)
        /// </summary>
        /// <param name="current"></param>
        /// <param name="nodes"></param>
        /// <param name="maxDistance"></param>
        /// <returns></returns>
        public static NodeEntity GetClosestNode(PersonEntity current, List<NodeEntity> nodes, int maxDistance = Int32.MaxValue)
        {
            var closest = nodes.Last();
            var closestDist = GeoTool.GetDistance(current.GetCoords(), closest.GetCoords());

            foreach (var node in nodes)
            {
                var dist = GeoTool.GetDistance(current.GetCoords(), node.GetCoords());
                if (dist > closestDist) continue;

                closest = node;
                closestDist = dist;
            }
            return (closestDist > maxDistance) ? null : closest;
        }

        /// <summary>
        /// Adds connection between defined node and cable
        /// </summary>
        /// <param name="cable"></param>
        /// <param name="node"></param>
        public static NodeCableEntity Connect(CableEntity cable, NodeEntity node)
        {

            var nodeCable = new NodeCableEntity { Cable = cable, Node = node };
            return nodeCable;
        }

        /// <summary>
        /// Connects the nodes in list(nodes) to eachother if the distance is less than specified(maxDist) and writes the cables to DB
        /// </summary>
        /// <param name="nodes"></param>
        /// <param name="maxDist"></param>
        public static void ConnectCloseNodes(List<NodeEntity> nodes, int maxDist)
        {
            Log.Info("Connecting nodes to nodes closer than " + maxDist + " kilometers");

            var cableHashes = new List<string>();

            var newCables = new List<CableEntity>();
            var newCableParts = new List<CablePartEntity>();

            foreach (var node1 in nodes)
            {
                foreach (var node2 in nodes)
                {
                    var foundDuplicate = false;
                    var dist = GeoTool.GetDistance(node1.GetCoords(), node2.GetCoords());

                    // Check if cable should be made
                    if (node1 == node2 || node1.GetSiblings().Contains(node2) || dist > maxDist || node1.GetSiblings().Count() > 2 || node2.GetSiblings().Count() > 2) continue;

                    // Make cable
                    var cable = new CableEntity(0, new CableTypeEntity() { Id = 0 }, 0, "Mini Cable");
                    cable.CableParts = new List<CablePartEntity>();
                    cable.Nodes = new List<NodeEntity>();

                    // Make cableparts
                    var cablePart1 = new CablePartEntity(cable, 0, node1.Lat, node1.Lng);
                    var cablePart2 = new CablePartEntity(cable, 1, node2.Lat, node2.Lng);

                    cable.CableParts.Add(cablePart1);
                    cable.CableParts.Add(cablePart2);

                    cable.Nodes.Add(node1);
                    cable.Nodes.Add(node2);

                    var coord1 = Coordinate.newLatLng(node1.Lat, node1.Lng);
                    var coord2 = Coordinate.newLatLng(node2.Lat, node2.Lng);

                    var hash1 = (coord1.lat + coord1.lng + coord2.lat + coord2.lng).ToString();

                    // Check if cable is already made
                    foreach (var cableHash in cableHashes)
                    {
                        if (cableHash != hash1) continue;
                        foundDuplicate = true;
                        break;

                    }

                    // Continue if cable is already made
                    if (foundDuplicate) continue;

                    // Write to database
                    newCables.Add(cable);

                    // Add to newCables list to prevent duplicate cables
                    cableHashes.Add(hash1);
                }
            }

            DBTool.WriteList(newCables);
            DBTool.WriteList(newCableParts);
            Log.Info("Made " + newCables.Count + " connections between nodes");
        }


        /// <summary>
        /// Connects all sea nodes to the closest land node and writes the cables to DB
        /// </summary>
        public static void ConnectSeaNodesToLand(int maxDistance = 10^12)
        {
            Log.Info("Connecting sea nodes to the closest land node");

            var landNodes = CacheEngine.Nodes.Where(x => x.Tier.Id == 1).ToList();
            var seaNodes = CacheEngine.Nodes.Where(x => x.Tier.Id == 4).ToList();
            var newCables = new List<CableEntity>();

            foreach (var seaNode in seaNodes)
            {
                var closest = GetClosestNode(seaNode, landNodes, maxDistance);
                if (closest == null) continue;
                newCables.Add(NewCable(seaNode, closest));
            }

            DBTool.WriteList(newCables);
            Log.Info("Made " + newCables.Count + " cables from sea nodes to land nodes");
        }

        public static void ConsistencyCheck(List<NodeEntity> nodes, List<CableEntity> cables)
        {


            foreach (var cable in cables)
            {
                if (cable.Nodes == null)
                {
                    Log.Error("Consistency check: Cable with ID " + cable.Id + "'s nodes is null");
                    continue;
                }
                if (cable.Nodes.Count == 0)
                    Log.Error("Consistency check: Cable with ID " + cable.Id + " is not connected to any nodes");
            }
        }
    }
}
