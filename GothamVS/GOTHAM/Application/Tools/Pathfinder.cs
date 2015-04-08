using System;
using System.Collections.Generic;
using System.Linq;
using GOTHAM.Model;
using GOTHAM_TOOLS;

namespace GOTHAM.Application.Tools
{
    /// <summary>
    /// This object contains a path of nodes generated from selected algorithm. Returns a stack of nodeID, NodeEntities or a dictionary of both.
    /// </summary>
    public class Pathfinder
    {
        /// <summary>
        /// Current solution. Is overwritten if a new algorithm is excuted.
        /// </summary>
        private List<KeyValuePair<int, NodeEntity>> _solution = new List<KeyValuePair<int, NodeEntity>>();


        /// <summary>
        /// Most basic algorithm for finding a reasonable path. This algorithm tries random paths a specified number of times and return the shortest. 
        /// </summary>
        /// <param name="start"></param>
        /// <param name="goal"></param>
        /// <param name="tryPaths"></param>
        /// <returns></returns>
        public Pathfinder TryRandom(NodeEntity start, NodeEntity goal, int tryPaths)
        {

            var tries = 0;
            var rnd = new Random();
            var minPath = Int32.MaxValue;

            // Run until end NodeEntity is reached
            while (tries < tryPaths)
            {
                var queue = new List<KeyValuePair<int, NodeEntity>>();
                var currentNode = start;
                var jumps = 0;

                queue.Add(new KeyValuePair<int, NodeEntity>(start.Id, start));

                do
                {
                    var nextNode = currentNode.GetSiblings()[rnd.Next(0, currentNode.GetSiblings().Count - 1)];

                    queue.Add(new KeyValuePair<int, NodeEntity>(nextNode.Id, nextNode));
                    currentNode = nextNode;
                    jumps++;

                } while (currentNode != goal && jumps < 100);

                if (currentNode == goal && queue.Count < minPath)
                {
                    // Console.WriteLine("FOUND A BETTER PATH");
                    _solution = queue;
                    minPath = queue.Count;
                }

                tries++;
            }

            return this;
        }

        /// <summary>
        /// INCOMPLETE: This algorithm should iterate through nodes trowards the end based on current location.
        /// </summary>
        /// <param name="start"></param>
        /// <param name="goal"></param>
        /// <returns></returns>
        public Pathfinder AStar(NodeEntity start, NodeEntity goal)
        {
            var ignore = new List<NodeEntity>();

            var currentNodeEntity = start;
            _solution.Add(new KeyValuePair<int, NodeEntity>(start.Id, start));

            // Run until end NodeEntity is reached
            do
            {
                NodeEntity nextNodeEntity = null;
                var minDist = Double.MaxValue;


                // Check siblings of currentNodeEntity for shortest distance
                foreach (var nodeEntity in currentNodeEntity.GetSiblings())
                {
                    var dist = GeoTool.GetDistance(nodeEntity.GetCoords(), goal.GetCoords());
                    if (!(dist < minDist) || ignore.Contains(nodeEntity)) continue;
                    minDist = dist;
                    nextNodeEntity = nodeEntity;
                }

                // If last NodeEntity is further away, add to ignore list and remove
                var lastDist = GeoTool.GetDistance(_solution.Last().Value.GetCoords(), goal.GetCoords());

                // Prevent possible nullpointer
                if (nextNodeEntity == null) continue;

                var currDist = GeoTool.GetDistance(nextNodeEntity.GetCoords(), goal.GetCoords());

                if (lastDist > currDist)
                {
                    _solution.Add(new KeyValuePair<int, NodeEntity>(nextNodeEntity.Id, nextNodeEntity));
                    ignore.Add(currentNodeEntity);
                    currentNodeEntity = nextNodeEntity;
                }
                else
                {
                    ignore.Add(_solution.Last().Value);
                    _solution.Remove(_solution.Last());
                }
            } while (currentNodeEntity != goal);
            return this;
        }


        // TODO: Test and improve when land nodes are added
        /// <summary>
        /// INCOMPLETE: This algorithm should find the shortest path based on nodes closest to a line between start and end.
        /// </summary>
        /// <param name="start"></param>
        /// <param name="goal"></param>
        /// <param name="nodes"></param>
        /// <returns></returns>
        public Pathfinder LinearStar(NodeEntity start, NodeEntity goal, List<NodeEntity> nodes)
        {
            var ignore = new List<NodeEntity>();
            var timeout = 0;
            var minPath = Int32.MaxValue;
            var time = DateTime.Now;

            // Run until end NodeEntity is reached
            while (timeout < 5000)
            {
                var queue = new List<KeyValuePair<int, NodeEntity>>();
                var currentNode = start;
                var tempIgnore = new List<NodeEntity>();
                var jumps = 0;

                queue.Add(new KeyValuePair<int, NodeEntity>(start.Id, start));

                do
                {
                    NodeEntity nextNode = null;
                    var minDist = Double.MaxValue;


                    // Check siblings of currentNodeEntity for shortest distance
                    foreach (var sibling in currentNode.GetSiblings())
                    {
                        var sibl = sibling;
                        var tmpDist = minDist;

                        foreach (var dist in sibling.GetSiblings()
                            .Select(sibling2 => GeoTool.GetDistance(sibling2.GetCoords(), goal.GetCoords()))
                            .Where(dist => dist < tmpDist && !ignore.Contains(sibl) && !tempIgnore.Contains(sibl)))
                        {
                            minDist = dist;
                            nextNode = sibling;
                        }
                    }

                    if (nextNode == null)
                    {
                        tempIgnore.Add(queue.Last().Value);
                        // Console.WriteLine("Dead end");
                        break;
                    }

                    // If last NodeEntity is further away, add to ignore list and remove
                    //var lastDist = GeoTool.GetDistance(queue.Last().Value.GetCoords(), goal.GetCoords());
                    //var currDist = GeoTool.GetDistance(nextNode.GetCoords(), goal.GetCoords());

                    queue.Add(new KeyValuePair<int, NodeEntity>(nextNode.Id, nextNode));
                    tempIgnore.Add(currentNode);
                    currentNode = nextNode;
                    ignore.Add(currentNode);
                    jumps++;

                } while (currentNode != goal && jumps < 100);

                if (currentNode == goal && queue.Count < minPath)
                {
                    _solution = queue;
                    minPath = queue.Count;
                    Console.WriteLine("FOUND A (BETTER) PATH WITH " + minPath);
                    return this;
                }

                timeout++;
            }
            Console.WriteLine("ClosestNode Path found in: " + (DateTime.Now - time).Milliseconds + " ms");
            return this;
        }

        /// <summary>
        /// NOT IMPLEMENTED YET: This algorithm finds the shortest path learning from pheromones generated by iterating through nodes.
        /// </summary>
        /// <param name="start"></param>
        /// <param name="goal"></param>
        public void Aco(NodeEntity start, NodeEntity goal)
        {

        }

        /// <summary>
        /// Returns the solution of the latest generated path as an Stack if Node ID's
        /// </summary>
        /// <returns></returns>
        public Stack<int> ToIdList()
        {
            var pathInt = new Stack<int>();

            foreach (var node in _solution)
                pathInt.Push(node.Key);

            return pathInt;
        }

        /// <summary>
        /// Returns the solution of the latest generated path as an Stack if NodeEntities
        /// </summary>
        /// <returns></returns>
        public Stack<NodeEntity> ToNodeList()
        {
            var pathInt = new Stack<NodeEntity>();

            foreach (var node in _solution)
                pathInt.Push(node.Value);

            return pathInt;
        }

        /// <summary>
        ///  Returns the solution of the latest generated path as a Dictionary of Node ID's and NodeEntities
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, NodeEntity> ToDictionary()
        {
            var pathInt = new Dictionary<int, NodeEntity>();

            foreach (var node in _solution)
            {
                // TODO: Remove nodes between duplicates (probably an unwanted loop)
                if (pathInt.ContainsKey(node.Key)) pathInt.Remove(node.Key);
                pathInt.Add(node.Key, node.Value);
            }
            return pathInt;
        }
    }
}
