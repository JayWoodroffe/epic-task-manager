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
    //when all projects are retrieved, preload their users too -> quick editing of projects for the admin
    [Authorize(Roles = "admin")]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<ProjectDto>>> GetProjects()
    {
        //fetching the project by ID and including active users
        var projectsWithUsers = await _context.Projects
            .Where(p => p.IsActive)
            .Include(p => p.Users)
            .ToListAsync();

        var projectsDto = projectsWithUsers.Select(p => new ProjectDto
        {
            Guid = p.Guid,
            Name = p.Name,
            Description = p.Description,
            Users = p.Users.Where(u => u.IsActive)
            .Select(u => new UserDto
            {
                Guid = u.Guid,
                FullName = u.FullName,
                Email = u.Email
            }).ToArray()
        }).ToList();
        return Ok(projectsDto);
    }


    //GET api/projects/{projectGuid}
    //TODO: check if this is needed -> when a project is being retrieved, the admin would have clicked on a project that already had all this info as per the ^ method
    [Authorize(Roles = "admin")] //only admins need access to all the information about the project
    [HttpGet("{projectGuid}")]
    public async Task<ActionResult<ProjectDto>> GetProjectByGuid(Guid projectGuid)
    {
        var projectId = await GuidHelpers.GetProjectIdByGuid(projectGuid, _context);

        if (projectId == null)
            return NotFound("Project not found.");

        //fetching the project by ID and including active users
        var projectsWithUsers = await _context.Projects
            .Where(p => p.Id == projectId && p.IsActive)
            .Include(p=>p.Users.Where(u => u.IsActive))
            .FirstOrDefaultAsync();

        if(projectsWithUsers == null)
            return NotFound("Project not found or inactive.");

        //create the DTOs, including the profiles of all the users associated with the project
        var projectsDto = new ProjectDto
        {
            Guid = projectsWithUsers.Guid,
            Name = projectsWithUsers.Name,
            Description = projectsWithUsers.Description,
            //users are included so admin can see who is attached to the project
            Users = projectsWithUsers.Users.Select(u => new UserDto
            {
                Guid = u.Guid,
                FullName = u.FullName,
                Email = u.Email
            }).ToArray()
        };

        return projectsDto;
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

    //step 1: extract user guid -> user id from token and use this in the createdby field? 
    //step 2: add to the userproject table between this new project and the logged in user

    // POST: api/projects
    [Authorize(Roles = "admin")] //only admins can create projects
    [HttpPost]
    public async Task<ActionResult<Project>> PostProject([FromBody] ProjectDto projectDto) //from body ensures that it takes the data directly from the json body
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

        //retrieving the user entity of the user that is creating the project
        var user = await _context.Siteusers.FindAsync(userId.Value);
        if (user == null)
            return NotFound("User entity not found.");

        //map DTO to entity
        var project = new Project
        {
            Guid = Guid.NewGuid(),
            Name = projectDto.Name,
            Description = projectDto.Description,
            CreatedById = user.Id,
            IsActive = true,
            Users = new List<Siteuser>()
        };

        project.Users.Add(user);//add the creator of the project to the project

        //add users from DTO if any
        if (projectDto.Users != null && projectDto.Users.Any())
        {
            //load users from the guids
            var userGuids = projectDto.Users.Select(u => u.Guid).ToList();
            var usersFromDb = await _context.Siteusers
                .Where(u => userGuids.Contains(u.Guid))
                .ToListAsync();

            foreach (var u in usersFromDb) //add these users to the project
            {
                //avoid duplicates
                if (!project.Users.Contains(u))
                    project.Users.Add(u);
            }
        }

        _context.Projects.Add(project);
        await _context.SaveChangesAsync();

        // Return DTO for response
        var resultDto = new ProjectDto
        {
            Guid = project.Guid,
            Name = project.Name,
            Description = project.Description,
            Users = project.Users.Select(u => new UserDto
            {
                Guid = u.Guid,
                FullName = u.FullName,
                Email = u.Email
            }).ToArray()
        };

        //var projectDto = new ProjectDto
        //{
        //    Guid = project.Guid,
        //    Name = project.Name,
        //    Description = project.Description,
        //    Users = null
        //};
        return CreatedAtAction(nameof(GetProjectByGuid), new { projectGuid = project.Guid }, resultDto);
    }


    //update
    // PUT: api/projects/5
    [HttpPut("{guid}")]
    public async Task<IActionResult> PutProject(Guid guid, ProjectDto projectDto)
    {
        if (guid != projectDto.Guid)
            return BadRequest();

        var projectId = await GuidHelpers.GetProjectIdByGuid(guid, _context);
        if (projectId == null)
            return NotFound();

        //getting the user that is updating the project
        var userGuidString = User.FindFirst("guid")?.Value;
        if (!Guid.TryParse(userGuidString, out var userGuid))
        {
            return Unauthorized("Invalid user GUID in token");
        }

        //convert user guid to int ID
        var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
        if (userId == null)
            return NotFound("User not found.");

        //retrieve the current project from the database 
        var project = await _context.Projects
            .Include(p => p.Users)
            .FirstOrDefaultAsync(p => p.Id == projectId && p.IsActive);

        if (project == null) return NotFound("Project not found");

        //update the basic fields
        project.Name = projectDto.Name;
        project.Description = projectDto.Description;
        project.UpdatedById = userId.Value; //set the user that updated the project
        project.UpdatedOn = DateTime.UtcNow; //set the updated date

        //update the user assignments
        //ensures that the user-project relationship is correctly mapped
        var newUsers = await _context.Siteusers
            .Where(u => projectDto.Users.Select(ud => ud.Guid).Contains(u.Guid))
            .ToListAsync();

        project.Users.Clear(); //clear existing users
        project.Users = newUsers; //assign the new users

        await _context.SaveChangesAsync();
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