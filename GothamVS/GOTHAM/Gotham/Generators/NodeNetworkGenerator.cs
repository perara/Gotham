using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Gotham.Model;
using Gotham.Model.Tools;
using Gotham.Tools;
using GOTHAM.Repository.Abstract;
using NHibernate.Util;

namespace Gotham.Gotham.Generators
{
    public class NodeNetworkGenerator
    {
        static Random rnd = new Random();


        public static void Generate()
        {

            var resultDNS = new List<DNSEntity>();
            var resultNetwork = new List<NetworkEntity>();


            var work = new UnitOfWork();

            // Create repositories
            var nodeRepo = work.GetRepository<NodeEntity>();
            var countryIPRepo = work.GetRepository<IPProviderEntity>();
            var networkRepo = work.GetRepository<NetworkEntity>();

            // Fetch DNS records with this provider
            var dnsRepo = work.GetRepository<DNSEntity>();

              


            // Fetch nodes with no network
            var nodes = nodeRepo.All().ToList();
            var networks = networkRepo.All().ToList();
            var dnsRecords = dnsRepo.All().ToList();

            // Fetch all countryIP records
            var countryIP = countryIPRepo.All().ToList();
            work.Dispose();


            // Foreach of the nodes
            foreach (var node in nodes)
            {
                if (networks.Exists(x => x.Node == node))
                    continue;


                // List of compatible IP Ranges for this host 
                var countryIPList = countryIP.Where(x => x.Country.CountryCode == node.CountryCode).ToList();

                // Ensure that countryIPlist is not empty, if it is. select closest country that has IPs available
                if (countryIPList.Count < 1)
                {

                    IPProviderEntity shortestCountryIP = null;
                    double distance = int.MaxValue;


                    foreach (var _node in nodes)
                    {

                        var countryipitem = countryIP.Where(x => x.Country.CountryCode == _node.CountryCode).FirstOrNull();
                        if (countryipitem == null) continue;


                        var distTest = GeoTool.GetDistance(new Coordinate.LatLng(_node.Lat, _node.Lng),
                            new Coordinate.LatLng(node.Lat, node.Lng));

                        if (distTest > distance) continue;

                        distance = distTest;
                        shortestCountryIP = (IPProviderEntity)countryipitem;


                    }

                    // Add to countryIP list
                    countryIPList = new List<IPProviderEntity> {shortestCountryIP};

                }



                // Fetch a random IP Provider
                int r = rnd.Next(countryIPList.Count);
                var randomIPProvider = countryIPList[r];
                

                // Get list of already distributed ips from this prodvider
                var freeDNSRange = dnsRecords
                    .Where(x => x.Provider == randomIPProvider)
                    .ToList();

                freeDNSRange.AddRange(resultDNS
                    .Where(x => x.Provider == randomIPProvider)
                    .ToList());

               

                

                // Get first free ip in the range
                var externalIP = firstAvailableIP(randomIPProvider, freeDNSRange);
                var internalIP = randomInternalIP();

                // Create new network record
                var network = new NetworkEntity();
                network.ExternalIPv4 = externalIP;
                network.InternalIPv4 = internalIP;
                network.Node = node;
                network.DNS = "4.4.4.4";
                network.Lat = node.Lat;
                network.Lng = node.Lng;
                network.Identity = null;
                network.Submask = "255.255.255.0"; // TODO? http://www.iplocation.net/subnet-mask
                network.IsLocal = false;

                // Create a DNS record for this network
                var dnsEntry = new DNSEntity();
                dnsEntry.Ipv4 = externalIP;
                dnsEntry.Ipv6 = null;
                dnsEntry.Address = null;
                dnsEntry.Provider = randomIPProvider;

                // ADD TO RESULT list
                resultDNS.Add(dnsEntry);
                resultNetwork.Add(network);
                Debug.WriteLine(externalIP);
            }

            // Save to db
            work = new UnitOfWork();
            work.GetRepository<DNSEntity>().Add(resultDNS);
            work.GetRepository<NetworkEntity>().Add(resultNetwork);
            work.Dispose();


        }

        private static string randomInternalIP()
        {
            // From http://en.wikipedia.org/wiki/Private_network
            var internalSpaces = new List<string>()
            {
                "10.0.0.0-10.255.255.255",
                "172.16.0.0-172.31.255.255",
                "192.168.0.0-192.168.255.255"
            };

            // Select random of internal spaces
            var selectedIPRange = internalSpaces[rnd.Next(internalSpaces.Count - 1)];

            // Set Start and Stop and split into an array
            var from = selectedIPRange.Split('-')[0].Split('.');
            var to = selectedIPRange.Split('-')[1].Split('.');

            var internalIP = String.Format("{0}.{1}.{2}.{3}",
                from[0],
                rnd.Next(int.Parse(from[1]), int.Parse(to[1])),
                rnd.Next(int.Parse(from[2]), int.Parse(to[1])),
                1);


            return internalIP;
        }


        private static string firstAvailableIP(IPProviderEntity provider, List<DNSEntity> dnsEntries)
        {
            // Define start and end
            var beginIP = provider.From.Split('.');
            var endIP = provider.To.Split('.');




            // Construct iterator
            // a = 255.0.0.0
            // b = 0.255.0.0
            // c = 0.0.255.0
            // d = 0.0.0.255
            string freeIP = null;
            for (int a = int.Parse(beginIP[0]); a <= int.Parse(endIP[0]); a++)
            {
                for (int b = int.Parse(beginIP[1]); b <= int.Parse(endIP[1]); b++)
                {
                    for (int c = int.Parse(beginIP[2]); c <= int.Parse(endIP[2]); c++)
                    {
                        for (int d = int.Parse(beginIP[3]); d <= int.Parse(endIP[3]); d++)
                        {
                            if (d == 0) continue;


                            freeIP = new IPAddress(new byte[] { (byte)a, (byte)b, (byte)c, (byte)d }).ToString();

                            if (dnsEntries.Where(x => x.Ipv4 == freeIP).FirstOrNull() == null)
                            {
                                return freeIP;
                            }
                        }// d = 0.0.0.255
                    } // c = 0.0.255.0
                }// b = 0.255.0.0
            }// a = 255.0.0.0




            return null;
        }



    }




}
