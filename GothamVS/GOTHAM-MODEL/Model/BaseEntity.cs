using Newtonsoft.Json;
using System.Diagnostics.CodeAnalysis;

namespace Gotham.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class BaseEntity
    {
        public virtual int Id { get; set; }

        [JsonIgnore]
        public virtual string Random { get; protected set; }

        public virtual string ToJson()
        {
          return JsonConvert.SerializeObject(this);
        }
    }
}
