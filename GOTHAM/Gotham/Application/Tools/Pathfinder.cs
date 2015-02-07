using GOTHAM.Tools;
using GOTHAM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections;

namespace GOTHAM_TOOLS
{
    public class Pathfinder
    {

        public static Stack<NodeEntity> TryRandom(NodeEntity start, NodeEntity goal, List<NodeEntity> nodes, int tryPaths)
        {
            var solution = new Stack<NodeEntity>();
            var tries = 0;
            var rnd = new Random();
            var minPath = Int32.MaxValue;
            var time = DateTime.Now;

            // Run until end NodeEntity is reached
            while (tries < tryPaths)
            {
                var queue = new Stack<NodeEntity>();
                var currentNode = start;
                var jumps = 0;

                queue.Push(start);

                do
                {
                    NodeEntity nextNode = null;
                    nextNode = currentNode.siblings[rnd.Next(currentNode.siblings.Count)];

                    queue.Push(nextNode);
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
            //Console.WriteLine("RandomAlgorithm Path found in: " + (DateTime.Now - time).Milliseconds + " ms, with " + solution.Count + " jumps");
            return solution;
        }

        public static Stack<NodeEntity> AStar(NodeEntity start, NodeEntity goal)
        {
            var queue = new Stack<NodeEntity>();
            var currentNodeEntity = new NodeEntity();
            var ignore = new List<NodeEntity>();

            currentNodeEntity = start;
            queue.Push(start);

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
                var lastDist = GeoTool.GetDistance(queue.Last().GetCoordinates(), goal.GetCoordinates());
                var currDist = GeoTool.GetDistance(nextNodeEntity.GetCoordinates(), goal.GetCoordinates());

                if (lastDist > currDist)
                {
                    queue.Push(nextNodeEntity);
                    ignore.Add(currentNodeEntity);
                    currentNodeEntity = nextNodeEntity;
                }
                else
                {
                    ignore.Add(queue.Last());
                    queue.Pop();
                }
            } while (currentNodeEntity != goal);
            return queue;
        }


        // TODO: Test and improve when land nodes are added
        public static Stack<NodeEntity> ByDistance(NodeEntity start, NodeEntity goal, List<NodeEntity> nodes)
        {
            var solution = new Stack<NodeEntity>();
            var ignore = new List<NodeEntity>();
            var timeout = 0;
            var tries = 0;
            var minPath = Int32.MaxValue;
            var time = DateTime.Now;

            // Run until end NodeEntity is reached
            while (timeout < 5000)
            {
                var queue = new Stack<NodeEntity>();
                var currentNode = start;
                var tempIgnore = new List<NodeEntity>();
                var jumps = 0;

                queue.Push(start);

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
                        tempIgnore.Add(queue.Last());
                        // Console.WriteLine("Dead end");
                        break;
                    }

                    // If last NodeEntity is further away, add to ignore list and remove
                    var lastDist = GeoTool.GetDistance(queue.Last().GetCoordinates(), goal.GetCoordinates());
                    var currDist = GeoTool.GetDistance(nextNode.GetCoordinates(), goal.GetCoordinates());

                    queue.Push(nextNode);
                    tempIgnore.Add(currentNode);
                    currentNode = nextNode;
                    jumps++;

                    //Console.WriteLine("Now in " + currentNodeEntity.country + ": " + currentNodeEntity.name);

                } while (currentNode != goal && jumps < 100);
                tries++;

                if (currentNode == goal && queue.Count < minPath)
                {
                    Console.WriteLine("FOUND A (BETTER) PATH");
                    solution = queue;
                    minPath = queue.Count;
                    return solution;
                }

                timeout++;
            }
            Console.WriteLine("ClosestNode Path found in: " + (DateTime.Now - time).Milliseconds + " ms");
            return solution;
        }

        //TODO: Implement
        public static void ACO(NodeEntity start, NodeEntity goal)
        {

        }
    }
}
