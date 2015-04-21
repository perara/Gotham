using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms.VisualStyles;
using Gotham.Model;
using GOTHAM.Repository.Abstract;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Gotham.Gotham.Parsers
{
    /// <summary>
    /// This parser takes in data from the countryIP.py script made to parse Country --> IP 
    /// </summary>
    public class CountryIPParser
    {

        public static void parse()
        {

            Debug.WriteLine("Parsing CountryIP File");
            using (StreamReader r = new StreamReader("I:\\Dropbox\\Shared Folders\\UIA-06 - DAT304\\CountryIP\\country_ip.json"))
            {
                string json = r.ReadToEnd();

                JObject obj = JObject.Parse(json);


                var countryIPs = new List<IPProviderEntity>();
                foreach (var item in obj)
                {
                    Console.WriteLine("Parsing Country: {0}", item.Key);


                    foreach (var ipBlock in item.Value.Children())
                    {

                        var countryIP = new IPProviderEntity();
                        countryIP.AssignDate = DateTime.Parse(ipBlock["assign_date"].ToString());
                        countryIP.From = ipBlock["from_ip"].ToString();
                        countryIP.To = ipBlock["to_ip"].ToString();
                        countryIP.CountryId = ipBlock["country_code"].ToString();


                        if (ipBlock["owner"] == null || ipBlock["owner"].ToString() == "")
                            countryIP.Owner = "None";
                        else
                            countryIP.Owner = ipBlock["owner"].ToString();

                        countryIPs.Add(countryIP);
                    }
                }

                var work = new UnitOfWork();
                work.GetRepository<IPProviderEntity>().Add(countryIPs);
                work.Dispose();



            }


        }

    }
}
