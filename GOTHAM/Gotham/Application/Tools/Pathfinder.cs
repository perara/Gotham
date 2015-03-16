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
    public class Pathfinder
    {
        public List<KeyValuePair<int, NodeEntity>> solution = new List<KeyValuePair<int, NodeEntity>>();


        public Pathfinder TryRandom(NodeEntity start, NodeEntity goal, List<NodeEntity> nodes, int tryPaths)
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
                    nextNode = currentNode.Siblings()[rnd.Next(currentNode.Siblings().Count)];

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
            //Console.WriteLine("RandomAlgorithm Path found in: " + (DateTime.Now - time).Milliseconds + " ms, with " + solution.Count + " jumps");
            return this;
        }

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
                foreach (var NodeEntity in currentNodeEntity.Siblings())
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
        public Pathfinder ByDistance(NodeEntity start, NodeEntity goal, List<NodeEntity> nodes)
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
                    foreach (var sibling1 in currentNode.Siblings())
                    {
                      foreach (var sibling2 in sibling1.Siblings())
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

                    //Console.WriteLine("Now in " + currentNodeEntity.country + ": " + currentNodeEntity.name);

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

        //TODO: Implement
        public void ACO(NodeEntity start, NodeEntity goal)
        {

        }

        public Stack<int> toIdList()
        {
            var pathInt = new Stack<int>();

            foreach (var node in solution)
                pathInt.Push(node.Key);

            return pathInt;
        }

        public Stack<NodeEntity> toNodeList()
        {
            var pathInt = new Stack<NodeEntity>();

            foreach (var node in solution)
                pathInt.Push(node.Value);

            return pathInt;
        }

        public Dictionary<int, NodeEntity> toDictionary()
        {
            var pathInt = new Dictionary<int, NodeEntity>();

            foreach (var node in solution)
                pathInt.Add(node.Key, node.Value);

            return pathInt;
        }
    }
}
