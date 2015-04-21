using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using FluentNHibernate.Mapping;
using Newtonsoft.Json;

namespace Gotham.Model
{
    [SuppressMessage("ReSharper", "DoNotCallOverridableMethodsInConstructor")]
    [SuppressMessage("ReSharper", "ClassWithVirtualMembersNeverInherited.Global")]
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")]
    [SuppressMessage("ReSharper", "VirtualMemberNeverOverriden.Global")]
    [SuppressMessage("ReSharper", "MemberCanBeProtected.Global")]
    [SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
    public class FilesystemEntity : BaseEntity
    {
        [JsonIgnore]
        public virtual FilesystemEntity Parent { get; set; }
        public virtual int Type { get; set; }
        public virtual IList<FilesystemEntity> Children { get; set; }
        public virtual string Name { get; set; }
        public virtual string Extension { get; set; }

   
        // Constructors
        protected FilesystemEntity() { }
        public FilesystemEntity(FilesystemEntity parent, String name, String extension)
        {
            this.Extension = extension;
            this.Name = name;
            this.Parent = parent;
        }
    }

    public class FileystemEntityMap : ClassMap<FilesystemEntity>
    {
        public FileystemEntityMap()
        {

            Table("filesystem");

            Id(x => x.Id, "id").GeneratedBy.Identity();

            Map(x => x.Type);
            Map(x => x.Name);
            Map(x => x.Extension);

            References(x => x.Parent, "parent")
                .Nullable()
                .Not.LazyLoad();

            HasMany(x => x.Children)
                .KeyColumn("parent")
                .Not.LazyLoad();

            Cache.NonStrictReadWrite().IncludeNonLazy().Region("LongTerm");
        }



    }
}
