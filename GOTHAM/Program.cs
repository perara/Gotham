using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Cache;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM
{
  class Program
  {
    static void Main(string[] args)
    {


      new FakeNameGenerator.FakeNameGenerator();

      new Gotham.Tools.HTTPRequest()
        .GET()
        .setURL("http://test.no")
        .execute();

      new Gotham.Tools.HTTPRequest()
        .POST()
        .setURL("http://test.no")
        .execute();



    }
  }

}
