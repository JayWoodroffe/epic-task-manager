using KanbanApi.Data;
using KanbanApi.Helpers;
using KanbanApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;


[Authorize] //ensure only logged-in users can access this controller
[Route("api/users")]
[ApiController]

public class UserControlelr : ControllerBase
{
    private readonly MyDbContext _context;
    public UserControlelr(MyDbContext context)
    {
        _context = context;
    }

    //return UserDto objects of all users in the database
    //GET: api/users/all
    [Authorize(Roles = "admin")] //only admins can access this endpoint
    [HttpGet]
    public async Task<ActionResult<IEnumerable<UserDto>>> GetAllUsers()
    {
        var users = await _context.Siteusers
            .Where(u => u.IsActive) //only active users
            .ToListAsync();

        if (users == null || !users.Any())
            return NotFound("No active users found.");

        var userDtos = users.Select(u => new UserDto
        {
            Email = u.Email,
            FullName = u.FullName,
            Guid = u.Guid
        }).ToList();

        return Ok(userDtos);
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

    //[HttpGet("{userguid}/projects")]
    //public async Task<ActionResult<IEnumerable<ProjectDto>>> GetProjectsByUser(Guid userGuid)
    //{
    //    var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
    //    if (userId == null)
    //        return NotFound();


    //    // Fetch projects associated with the user
    //    var projects = await _context.Siteusers
    //    .Where(u => u.Id == userId)
    //    .Include(u => u.Projects)
    //    .SelectMany(u => u.Projects)
    //    .Select(p => new ProjectDto
    //    {
    //        Guid = p.Guid,
    //        Name = p.Name,
    //        Description = p.Description
    //    })
    //    .ToListAsync();
    //    if (projects == null || !projects.Any())
    //        return NotFound();
    //    return projects;
    //}
}