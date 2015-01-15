using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GOTHAM.Gotham.Application.Model
{
 public class HostEntity
  {

    public virtual int id { get; set; }
    public virtual string machineName { get; set; }
    public virtual bool online { get; set; }
    public virtual PersonEntity owner { get; set; }
  }
}
