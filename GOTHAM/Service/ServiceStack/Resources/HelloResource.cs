using System;
using System.Collections.Generic;
using ServiceStack;
// ReSharper disable All

namespace GOTHAM.Service.ServiceStack.Resources
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
          var lol = new List<string> {"alslada", "AKSFAKF"};
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
