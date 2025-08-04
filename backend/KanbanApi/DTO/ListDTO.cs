public class ListDto
{
    public Guid Guid { get; set; }
    public string Name { get; set; }
    public string Status { get; set; } 
    public string Color { get; set; }
    public TaskDto[]? Tasks { get; set; }
    public int Position { get; set; }
}