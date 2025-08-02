using KanbanApi.Data;
using KanbanApi.Helpers;
using KanbanApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.Elfie.Diagnostics;

[Authorize] //only logged-in users can access this controller
[Route("api/lists")]
[ApiController]
public class ListController : ControllerBase
{
    private readonly MyDbContext _context;
    public ListController(MyDbContext context)
    {
        _context = context;
    }

    //retrieves all lists 
    // GET: api/lists
    [Authorize(Roles = "admin")]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<ListDto>>> GetLists()
    {
        var lists = await _context.Lists
            .Where(l => l.IsActive) //active lists only
            .Include(l=>l.Status)//include the status of the list
            .ToListAsync();
    var listDtos = lists.Select(l => new ListDto
    {
        Guid = l.Guid,
        Name = l.Name,
        Status = l.Status.Name, //status name instead of ID
        Color = l.Status.Color, //status color
        Tasks = l.Tasks.Where(t => t.IsActive).Select(t => new TaskDto
        {
            Guid = t.Guid,
            Name = t.Name,
            Position = t.Position
        }).ToArray(),
    }).ToList();
        return Ok(listDtos);
    }

    ////GET api/lists/{listguid}
    [Authorize(Roles = "admin")] //only admins need access to all the information about the list
    [HttpGet("{listGuid}")]
    public async Task<ActionResult<ListDto>> GetListByGuid(Guid guid)
    {
        var listId = await GuidHelpers.GetListIdByGuid(guid, _context);

        if (listId == null)
            return NotFound("List not found.");

        //fetching the list by ID 
        var list = await _context.Lists
            .Where(p => p.Id == listId && p.IsActive)
            .FirstOrDefaultAsync();

        if (list == null)
            return NotFound("List not found or inactive.");

        //create the DTOs, including the profiles of all the users associated with the project
        var listDto = new ListDto
        {
            Guid = list.Guid,
            Name = list.Name,
            Status = list.Status.Name, //status name instead of ID
            Color = list.Status.Color, //status color
            Tasks = list.Tasks.Where(t => t.IsActive).Select(t => new TaskDto
            {
                Guid = t.Guid,
                Name = t.Name,
                Position = t.Position,
                ListId = list.Guid
            }).ToArray(),
            Position = list.Position
        };

        return listDto;
    }

    //retrieve lists for a specific board
    [HttpGet("board/{boardGuid}")]
    public async Task<ActionResult<IEnumerable<ListDto>>> GetListsByBoard(Guid boardGuid)
    {
        var boardId = await GuidHelpers.GetBoardIdByGuid(boardGuid, _context);
        if (boardId == null)
            return NotFound("Board not found.");

        // Fetch lists associated with the board
        var board = await _context.Boards
            .Where(b => b.IsActive && b.Id == boardId)
            .Include(b => b.Lists.Where(l => l.IsActive))
            .FirstOrDefaultAsync();

        var lists = board?.Lists;

        if (lists == null || !lists.Any())
            return Ok(new List<ListDto>()); //returns an empty list (of lists) if no lists are found
        //convert lists to DTOs
        var listsDto = lists.Select(b => new ListDto
        {
            Guid = b.Guid,
            Name = b.Name,
            Status = b.Status.Name, //status name instead of ID
            Color = b.Status.Color, //status color
            Tasks = b.Tasks.Where(t => t.IsActive).Select(t => new TaskDto
            {
                Guid = t.Guid,
                Name = t.Name,
                Position = t.Position,
                ListId = b.Guid
            }).ToArray(),
        }).ToList();

        return Ok(listsDto);
    }

    // POST: api/lists
    //create new lists
    [HttpPost("{boardGuid}")]
    public async Task<ActionResult<Board>> PostList(Guid boardGuid, [FromBody] ListDto listDto) //from body ensures that it takes the data directly from the json body
    {
        //getting the board that this list is being created in
        var boardId = await GuidHelpers.GetBoardIdByGuid(boardGuid, _context);
        var board = await _context.Boards
            .Where(b => b.IsActive && b.Id == boardId)
            .FirstOrDefaultAsync();

        var userGuidString = User.FindFirst("guid")?.Value;
        if (!Guid.TryParse(userGuidString, out var userGuid))
        {
            return Unauthorized("Invalid user GUID in token");
        }

        //convert guid to int ID
        var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
        if (userId == null)
            return NotFound("User not found.");

        //retrieving the user entity of the user that is creating the list
        var user = await _context.Siteusers.FindAsync(userId.Value);
        if (user == null)
            return NotFound("User entity not found.");

        //map DTO to entity
        var list = new List
        {
            Guid = Guid.NewGuid(),
            Name = listDto.Name,
            StatusId = await _context.Statuses
                .Where(s => s.Name == listDto.Status && s.IsActive)
                .Select(s => s.Id)
                .FirstOrDefaultAsync(),
            //Color = listDto.Color,
            CreatedById = user.Id,
            CreatedOn = DateTime.UtcNow,
            IsActive = true,
            BoardId = board.Id,
            Position = listDto.Position
        };


        _context.Lists.Add(list);
        await _context.SaveChangesAsync();

        // Return DTO for response
        var resultDto = new ListDto
        {
            Guid = list.Guid,
            Name = list.Name,
            Position = list.Position,
        };
        return CreatedAtAction(nameof(GetListByGuid), new { listGuid = list.Guid }, resultDto);
    }


    //update a list
    // PUT: api/lists/5
    [HttpPut("{guid}")]
    public async Task<IActionResult> PutList(Guid guid, ListDto listDto)
    {
        if (guid != listDto.Guid)
            return BadRequest();

        var listId = await GuidHelpers.GetListIdByGuid(guid, _context);
        if (listId == null)
            return NotFound();

        //retrieve the current list from the database 
        var list = await _context.Lists
            .FirstOrDefaultAsync(l => l.Id == listId && l.IsActive);

        if (list == null) return NotFound("List not found");

        //update the basic fields
        list.Name = listDto.Name;
        list.StatusId = await _context.Statuses
            .Where(s => s.Name == listDto.Status && s.IsActive)
            .Select(s => s.Id)
            .FirstOrDefaultAsync();
        //TODO figure out color
        list.Position = listDto.Position;

        await _context.SaveChangesAsync();
        return NoContent();
    }

    // DELETE: api/lists/5
    [HttpDelete("{guid}")]
    public async Task<IActionResult> DeleteList(Guid guid)
    {
        if (guid == null)
            return Unauthorized("Missing list GUID in token");


        //convert guid to int ID
        var listId = await GuidHelpers.GetListIdByGuid(guid, _context);
        if (listId == null)
            return NotFound("List not found.");

        var list = await _context.Lists
            .Where(b => b.Id == listId && b.IsActive)
            .FirstOrDefaultAsync();

        if (list == null)
            return NotFound("List not found.");

        //soft delete
        list.IsActive = false;

        await _context.SaveChangesAsync();
        return NoContent();
    }

    private bool ListExists(int id)
    {
        return _context.Lists.Any(e => e.Id == id);
    }

}