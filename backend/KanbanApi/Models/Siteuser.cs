using System;
using System.Collections.Generic;

namespace KanbanApi.Models;

public partial class Siteuser:BaseModel
{
    //public int Id { get; set; }

    //public Guid Guid { get; set; }

    public string Email { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string? FullName { get; set; }

    public string? Role { get; set; }

    //public int? CreatedById { get; set; }

    //public DateTime CreatedOn { get; set; }

    //public int? UpdatedById { get; set; }

    //public DateTime? UpdatedOn { get; set; }

    //public bool? IsActive { get; set; }

    public virtual ICollection<Board> BoardCreatedBies { get; set; } = new List<Board>();

    public virtual ICollection<Board> BoardUpdatedBies { get; set; } = new List<Board>();

    public virtual ICollection<List> ListCreatedBies { get; set; } = new List<List>();

    public virtual ICollection<List> ListUpdatedBies { get; set; } = new List<List>();

    public virtual ICollection<Project> ProjectCreatedBies { get; set; } = new List<Project>();

    public virtual ICollection<Project> ProjectUpdatedBies { get; set; } = new List<Project>();

    public virtual ICollection<Status> StatusCreatedBies { get; set; } = new List<Status>();

    public virtual ICollection<Status> StatusUpdatedBies { get; set; } = new List<Status>();

    public virtual ICollection<Task> TaskCreatedBies { get; set; } = new List<Task>();

    public virtual ICollection<Task> TaskUpdatedBies { get; set; } = new List<Task>();

    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();
}
