using System.Linq;
using System.Web.Http;
using GOTHAM.Model;
using GOTHAM.Repository.Abstract;


namespace GOTHAM.Service.WebAPI.Resources
{
    public class NodeController : ApiController
    {

        public object GetNodes()
        {

            var work = new UnitOfWork();
            var nodes = work.GetRepository<NodeEntity>().All().ToList();
            var cables = work.GetRepository<NodeEntity>().All().ToList();
            work.Dispose();

            return new
            {
                nodes = nodes,
                cables = cables
            };
        }
    }
}
