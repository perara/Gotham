using System;
using System.Collections.Generic;
using System.Web.Http;
using GOTHAM.Application.Tools.Cache;
using GOTHAM.Model;

namespace GOTHAM.Service.WebAPI.Resources
{
    public class NodeController : ApiController
    {

        public object GetNodes()
        {
            return new
            {
                nodes = CacheEngine.Nodes,
                cables = CacheEngine.Cables
            };
        }
    }
}
