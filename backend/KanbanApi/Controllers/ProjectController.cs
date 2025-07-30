using KanbanApi.Data;
using KanbanApi.Helpers;
using KanbanApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

using Microsoft.AspNetCore.Mvc;

[Authorize]//only logged-in users can access this controller
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

    //GET api/projects/{projectGuid}
    [HttpGet("{projectGuid}")]
    public async Task<ActionResult<Project>> GetProjectByGuid(Guid projectGuid)
    {
        var projectId = await GuidHelpers.GetProjectIdByGuid(projectGuid, _context);

        if (projectId == null)
            return NotFound("Project not found.");

        //fetching the project by ID and including active usersgithub

        var project = await _context.Projects
            .Where(p => p.Id == projectId && p.IsActive)
            .Include(p=>p.Users.Where(u => u.isActive))
            .FirstOrDefaultAsync();


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

    //get projects based on logged in user
    [HttpGet("myprojects")]
    public async Task<ActionResult<IEnumerable<ProjectDto>>> GetMyProjects()
    {
        //get the user guid from the token
        var userGuidString = User.Claims.FirstOrDefault(c => c.Type == "guid")?.Value;
        if (!Guid.TryParse(userGuidString, out var userGuid))
        {
            return Unauthorized("Invalid user GUID in token");
        }

        //convert guid to int ID
        var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
        if (userId == null)
            return NotFound("User not found.");

        // Fetch projects associated with the user
        var userWithProjects = await _context.Siteusers
            .Where(u => u.Id == userId)
            .Include(u => u.Projects.Where(p=>p.IsActive))
            .Where(p => p.IsActive)
            .FirstOrDefaultAsync();

        if (userWithProjects == null || userWithProjects.Projects == null)
            return NotFound("No projects found for this user");

        var projectsDto = userWithProjects.Projects.Select(p => new ProjectDto
        {
            Guid = p.Guid,
            Name = p.Name,
            Description = p.Description,
        });
        return Ok(projectsDto);
    }

    //TODO: make sure all metdadata fields are set correctly
    //make sure the project-user relationship is set up correctly to allow access
    // POST: api/projects
    [Authorize(Roles = "admin")] //only admins can create projects
    [HttpPost]
    public async Task<ActionResult<Project>> PostProject(Project project)
    {
        var userGuidString = User.FindFirst("guid")?.Value;
        if (!Guid.TryParse(userGuidString, out var userGuid))
        {
            return Unauthorized("Invalid user GUID in token");
        }

        //convert guid to int ID
        var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
        if (userId == null)
            return NotFound("User not found.");

        project.Guid = Guid.NewGuid(); //generate a new GUID for the project
        project.CreatedById = userId.Value; //set the creator of the project


        _context.Projects.Add(project);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetProjectByGuid), new { guid = project.Guid }, project);
    }


    // PUT: api/projects/5
    [HttpPut("{guid}")]
    public async Task<IActionResult> PutProject(Guid guid, Project project)
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
    [Authorize(Roles = "admin")]
    [HttpDelete("{guid}")]
    public async Task<IActionResult> DeleteProject(Guid guid)
    {
        if (guid == null)
            return Unauthorized("Missing project GUID in token");
        

        //convert guid to int ID
        var projectId = await GuidHelpers.GetProjectIdByGuid(guid, _context);
        if (projectId == null)
            return NotFound("Project not found.");

        var project = await _context.Projects
            .Include(p=>p.Users)
            .Where(p=>p.Id == projectId &&p.IsActive)
            .FirstOrDefaultAsync();

        if (project == null)
            return NotFound("Project not found.");

        //soft delete
        project.IsActive = false;

        await _context.SaveChangesAsync();
        return NoContent();
    }
    private bool ProjectExists(int id)
    {
        return _context.Projects.Any(e => e.Id == id);
    }

}