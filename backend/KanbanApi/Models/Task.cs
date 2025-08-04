using System;
using System.Collections.Generic;

namespace KanbanApi.Models;

public partial class Task:BaseModel
{
    //public int Id { get; set; }

    //public Guid Guid { get; set; }

    //public int? CreatedById { get; set; }

    //public DateTime? CreatedOn { get; set; }

    //public int? UpdatedById { get; set; }

    //public DateTime? UpdatedOn { get; set; }

    //public sbyte IsActive { get; set; }

    public string Name { get; set; } = null!;

    public int ListId { get; set; }

    public int Position { get; set; }

    public virtual Siteuser? CreatedBy { get; set; }

    public virtual List List { get; set; } = null!;

    public virtual Siteuser? UpdatedBy { get; set; }
}
