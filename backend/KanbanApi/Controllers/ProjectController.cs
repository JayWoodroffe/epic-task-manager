using KanbanApi.Data;
using KanbanApi.Helpers;
using KanbanApi.Models;
using Microsoft.EntityFrameworkCore;

using Microsoft.AspNetCore.Mvc;

[Route("api/projects")]
[ApiController]
public class ProjectController : ControllerBase
{
    private readonly MyDbContext _context;
    public ProjectController(MyDbContext context)
    {
        _context = context;
    }

    //removing methods that would expose the int ID (as this is a security risk)
    // GET: api/projects
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Project>>> GetProjects()
    {
        return await _context.Projects.ToListAsync();
    }

    //// GET: api/projects/5
    //[HttpGet("{id}")]
    //public async Task<ActionResult<Project>> GetProject(int id)
    //{
    //    var project = await _context.Projects.FindAsync(id);
    //    if (project == null)
    //        return NotFound();
    //    return project;
    //}

    //GET api/projects/guid/{projectGuid}
    [HttpGet("guid/{projectGuid}")]
    public async Task<ActionResult<Project>> GetProjectByGuid(Guid projectGuid)
    {
        var project = await _context.Projects.FirstOrDefaultAsync(p => p.Guid == projectGuid);
        if (project == null)
            return NotFound();
        return project;
    }

    [HttpGet("{projectGuid}/boards")]
    public async Task<ActionResult<IEnumerable<Board>>> GetBoardsByProject(Guid projectGuid)
    {
    var projectId = await GuidHelpers.GetProjectIdByGuid(projectGuid, _context);
    if(projectId == null)
            return NotFound();

    // Fetch boards associated with the project
    //can use include due to the scaffolding of the project model 
    var boards = await _context.Projects
            .Where(p => p.Id == projectId)
            .Include(p => p.Boards)
            .SelectMany(p => p.Boards)
            .ToListAsync();
    if (boards == null || !boards.Any())
            return NotFound();
        return boards;
    }   

// POST: api/projects
[HttpPost]
    public async Task<ActionResult<Project>> PostProject(Project project)
    {
        _context.Projects.Add(project);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetProjectByGuid), new { guid = project.Guid }, project);
    }
    // PUT: api/projects/5
    [HttpPut("{id}")]
    public async Task<IActionResult> PutProject(int id, Project project)
    {
        if (id != project.Id)
            return BadRequest();
        _context.Entry(project).State = EntityState.Modified;
        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!ProjectExists(id))
                return NotFound();
            else
                throw;
        }
        return NoContent();
    }
    // DELETE: api/projects/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteProject(int id)
    {
        var project = await _context.Projects.FindAsync(id);
        if (project == null)
            return NotFound();
        _context.Projects.Remove(project);
        await _context.SaveChangesAsync();
        return NoContent();
    }
    private bool ProjectExists(int id)
    {
        return _context.Projects.Any(e => e.Id == id);
    }

}