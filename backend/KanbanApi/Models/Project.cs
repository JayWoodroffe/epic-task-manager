using System;
using System.Collections.Generic;

namespace KanbanApi.Models;

public partial class Project: BaseModel
{
    public string? Name { get; set; }

    public string? Description { get; set; }

    public virtual Siteuser CreatedBy { get; set; } = null!;

    public virtual Siteuser? UpdatedBy { get; set; }

    public virtual ICollection<Board> Boards { get; set; } = new List<Board>();

    public virtual ICollection<Siteuser> Users { get; set; } = new List<Siteuser>();
}
