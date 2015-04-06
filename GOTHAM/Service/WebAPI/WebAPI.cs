using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.SelfHost;

namespace GOTHAM.Service.WebAPI
{
    public class WebApi
    {

        public WebApi()
        {
            var baseAddress = new Uri("http://localhost:8085");
            var config = new HttpSelfHostConfiguration(baseAddress);
            config.MessageHandlers.Add(new CustomHeaderHandler());
            config.Formatters.JsonFormatter.SupportedMediaTypes.Add(new MediaTypeHeaderValue("text/html"));
            config.Routes.MapHttpRoute(
                "API Default", "api/{controller}/{id}",
                new { id = RouteParameter.Optional });

            using (HttpSelfHostServer server = new HttpSelfHostServer(config))
            {
                server.OpenAsync().Wait();
                Console.ReadLine();
            }


        }


        public class CustomHeaderHandler : DelegatingHandler
        {
            protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, System.Threading.CancellationToken cancellationToken)
            {
                return base.SendAsync(request, cancellationToken)
                    .ContinueWith((task) =>
                    {
                        HttpResponseMessage response = task.Result;
                        response.Headers.Add("Access-Control-Allow-Origin", "*");
                        return response;
                    });
            }
        }


    }
}
