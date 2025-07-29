using KanbanApi.Data;
using KanbanApi.Helpers;
using KanbanApi.Models;
using Microsoft.EntityFrameworkCore;

using Microsoft.AspNetCore.Mvc;

[Route("api/users")]
[ApiController]

public class UserControlelr: ControllerBase
{
    private readonly MyDbContext _context;
    public UserControlelr(MyDbContext context)
    {
        _context = context;
    }


    // GET: api/users
    //[HttpGet]
    //public async Task<ActionResult<IEnumerable<Siteuser>>> GetUsers()
    //{
    //    return await _context.Users.ToListAsync();
    //}


    // GET: api/users/guid/{userGuid}
    //[HttpGet("guid/{userGuid}")]
    //public async Task<ActionResult<User>> GetUserByGuid(Guid userGuid)
    //{
    //    var user = await _context.Users.FirstOrDefaultAsync(u => u.Guid == userGuid);
    //    if (user == null)
    //        return NotFound();
    //    return user;
    //}

    [HttpGet("{userguid}/projects")]
    public async Task<ActionResult<IEnumerable<ProjectDto>>> GetProjectsByUser(Guid userGuid)
    {
        var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
        if (userId == null)
            return NotFound();


        // Fetch projects associated with the user
        var projects = await _context.Siteusers
        .Where(u => u.Id == userId)
        .Include(u => u.Projects)
        .SelectMany(u => u.Projects)
        .Select(p => new ProjectDto
        {
            Guid = p.Guid,
            Name = p.Name,
            Description = p.Description
        })
        .ToListAsync();
        if (projects == null || !projects.Any())
            return NotFound();
        return projects;
    }
}