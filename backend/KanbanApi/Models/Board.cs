using System;
using System.Collections.Generic;

namespace KanbanApi.Models;

public partial class Board :BaseModel
{
    //public int Id { get; set; }

    //public Guid Guid { get; set; }

    //public int CreatedById { get; set; }

    //public DateTime CreatedOn { get; set; }

    //public int? UpdatedById { get; set; }

    //public DateTime? UpdatedOn { get; set; }

    //public sbyte IsActive { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public virtual Siteuser CreatedBy { get; set; } = null!;

    public virtual ICollection<List> Lists { get; set; } = new List<List>();

    public virtual Siteuser? UpdatedBy { get; set; }

    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();
}
