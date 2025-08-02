public class TaskDto
{
    public Guid Guid { get; set; }
    public string Name { get; set; }
    public int Position { get; set; }
    public Guid ListId { get; set; } // to associate the task with a list

}