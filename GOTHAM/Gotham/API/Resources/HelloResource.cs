using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceStack;

namespace GOTHAM.Gotham.API.Resources
{

  public class HelloResource
  {


    [Route("/hello")]
    public class HelloName
    {
      public string Name { get; set; }
    }

    public class HelloCar
    {
      public string Car { get; set; }
    }


    public class Hello
    {}
    

    /// <summary>
    /// Response Template
    /// </summary>
    public class HelloResponse
    {
      public string Result { get; set; }
    }

    /// <summary>
    ///  Service Binder
    /// </summary>
    public class HelloService : IService
    {
      public String Any(HelloCar car)
      {
        return car.Car;
      }

      public List<String> Any(Hello hey)
      {
        List<String> lol = new List<string>();
        lol.Add("alslada");
        lol.Add("AKSFAKF");


        return lol;
      }

      public object Any(HelloName request)
      {
        //Looks strange when the name is null so we replace with a generic name.
        var name = request.Name ?? "John Doe";
        return new HelloResponse { Result = "Hello, " + name };
      }
    }
  }




}
