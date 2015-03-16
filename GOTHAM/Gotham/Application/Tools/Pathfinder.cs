using GOTHAM.Tools;
using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections;

namespace GOTHAM.Tools
{
    /// <summary>
    /// This object contains a path of nodes generated from selected algorithm. Returns a stack of nodeID, NodeEntities or a dictionary of both.
    /// </summary>
    public class Pathfinder
    {
        /// <summary>
        /// Current solution. Is overwritten if a new algorithm is excuted.
        /// </summary>
        public List<KeyValuePair<int, NodeEntity>> solution = new List<KeyValuePair<int, NodeEntity>>();


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
            var time = DateTime.Now;

            // Run until end NodeEntity is reached
            while (tries < tryPaths)
            {
                var queue = new List<KeyValuePair<int, NodeEntity>>();
                var currentNode = start;
                var jumps = 0;

                queue.Add(new KeyValuePair<int,NodeEntity>(start.id, start));

                do
                {
                    NodeEntity nextNode = null;
                    nextNode = currentNode.siblings[rnd.Next(currentNode.siblings.Count)];

                    queue.Add(new KeyValuePair<int,NodeEntity>(nextNode.id, nextNode));
                    currentNode = nextNode;
                    jumps++;

                } while (currentNode != goal && jumps < 100);
  
                if (currentNode == goal && queue.Count < minPath)
                {
                    // Console.WriteLine("FOUND A BETTER PATH");
                    solution = queue;
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
            var currentNodeEntity = new NodeEntity();
            var ignore = new List<NodeEntity>();

            currentNodeEntity = start;
            solution.Add(new KeyValuePair<int,NodeEntity>(start.id, start));

            // Run until end NodeEntity is reached
            do
            {
                NodeEntity nextNodeEntity = null;
                var minDist = Double.MaxValue;


                // Check siblings of currentNodeEntity for shortest distance
                foreach (var NodeEntity in currentNodeEntity.siblings)
                {
                    var dist = GeoTool.GetDistance(NodeEntity.GetCoordinates(), goal.GetCoordinates());
                    if (dist < minDist && !ignore.Contains(NodeEntity))
                    {
                        minDist = dist;
                        nextNodeEntity = NodeEntity;
                    }
                }

                // If last NodeEntity is further away, add to ignore list and remove
                var lastDist = GeoTool.GetDistance(solution.Last().Value.GetCoordinates(), goal.GetCoordinates());
                var currDist = GeoTool.GetDistance(nextNodeEntity.GetCoordinates(), goal.GetCoordinates());

                if (lastDist > currDist)
                {
                    solution.Add(new KeyValuePair<int,NodeEntity>(nextNodeEntity.id, nextNodeEntity));
                    ignore.Add(currentNodeEntity);
                    currentNodeEntity = nextNodeEntity;
                }
                else
                {
                    ignore.Add(solution.Last().Value);
                    solution.Remove(solution.Last());
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
            var tries = 0;
            var minPath = Int32.MaxValue;
            var time = DateTime.Now;

            // Run until end NodeEntity is reached
            while (timeout < 5000)
            {
                var queue = new List<KeyValuePair<int, NodeEntity>>();
                var currentNode = start;
                var tempIgnore = new List<NodeEntity>();
                var jumps = 0;

                queue.Add(new KeyValuePair<int,NodeEntity>(start.id, start));

                do
                {
                    NodeEntity nextNode = null;
                    var minDist = Double.MaxValue;
                    

                    // Check siblings of currentNodeEntity for shortest distance
                    foreach (var sibling1 in currentNode.siblings)
                    {
                        foreach (var sibling2 in sibling1.siblings)
                        {
                            var dist = GeoTool.GetDistance(sibling2.GetCoordinates(), goal.GetCoordinates());
                            if (dist < minDist && !ignore.Contains(sibling1) && !tempIgnore.Contains(sibling1))
                            {
                                minDist = dist;
                                nextNode = sibling1;
                            }
                        }
                    }

                    if (nextNode == null)
                    {
                        tempIgnore.Add(queue.Last().Value);
                        // Console.WriteLine("Dead end");
                        break;
                    }

                    // If last NodeEntity is further away, add to ignore list and remove
                    var lastDist = GeoTool.GetDistance(queue.Last().Value.GetCoordinates(), goal.GetCoordinates());
                    var currDist = GeoTool.GetDistance(nextNode.GetCoordinates(), goal.GetCoordinates());

                    queue.Add(new KeyValuePair<int,NodeEntity>(nextNode.id, nextNode));
                    tempIgnore.Add(currentNode);
                    currentNode = nextNode;
                    jumps++;

                } while (currentNode != goal && jumps < 100);
                tries++;

                if (currentNode == goal && queue.Count < minPath)
                {
                    Console.WriteLine("FOUND A (BETTER) PATH");
                    solution = queue;
                    minPath = queue.Count;
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
        public void ACO(NodeEntity start, NodeEntity goal)
        {

        }

        /// <summary>
        /// Returns the solution of the latest generated path as an Stack if Node ID's
        /// </summary>
        /// <returns></returns>
        public Stack<int> toIdList()
        {
            var pathInt = new Stack<int>();

            foreach (var node in solution)
                pathInt.Push(node.Key);

            return pathInt;
        }

        /// <summary>
        /// Returns the solution of the latest generated path as an Stack if NodeEntities
        /// </summary>
        /// <returns></returns>
        public Stack<NodeEntity> toNodeList()
        {
            var pathInt = new Stack<NodeEntity>();

            foreach (var node in solution)
                pathInt.Push(node.Value);

            return pathInt;
        }

        /// <summary>
        ///  Returns the solution of the latest generated path as a Dictionary of Node ID's and NodeEntities
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, NodeEntity> toDictionary()
        {
            var pathInt = new Dictionary<int, NodeEntity>();

            foreach (var node in solution)
                pathInt.Add(node.Key, node.Value);

            return pathInt;
        }
    }
}
