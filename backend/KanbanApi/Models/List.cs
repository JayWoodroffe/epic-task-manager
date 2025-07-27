using System;
using System.Collections.Generic;

namespace KanbanApi.Models;

public partial class List
{
    public int Id { get; set; }

    public Guid Guid { get; set; }

    public int? CreatedById { get; set; }

    public DateTime? CreatedOn { get; set; }

    public int? UpdatedById { get; set; }

    public DateTime? UpdatedOn { get; set; }

    public sbyte IsActive { get; set; }

    public string Name { get; set; } = null!;

    public int BoardId { get; set; }

    public int StatusId { get; set; }

    public int Position { get; set; }

    public virtual Board Board { get; set; } = null!;

    public virtual Siteuser? CreatedBy { get; set; }

    public virtual Status Status { get; set; } = null!;

    public virtual ICollection<Task> Tasks { get; set; } = new List<Task>();

    public virtual Siteuser? UpdatedBy { get; set; }
}
