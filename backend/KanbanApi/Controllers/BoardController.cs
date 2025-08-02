using KanbanApi.Data;
using KanbanApi.Helpers;
using KanbanApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

using Microsoft.AspNetCore.Mvc;

[Authorize] //only logged-in users can access this controller
[Route("api/boards")]
[ApiController]
public class BoardController : ControllerBase
{
    private readonly MyDbContext _context;
    public BoardController(MyDbContext context)
    {
        _context = context;
    }

    //retrieves all boards
    // GET: api/boards
    [Authorize(Roles = "admin")]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<BoardDto>>> GetBoards()
    {
        var boards = await _context.Boards
            .Where(b => b.IsActive)
            .ToListAsync();
        var boardDtos = boards.Select(b => new BoardDto
        {
            Guid = b.Guid,
            Name = b.Name,
            Description = b.Description,
        }).ToList();
        return Ok(boardDtos);
    }

    //GET api/boards/{boardsGuid}
    //TODO: check if this is needed -> when a project is being retrieved, the admin would have clicked on a project that already had all this info as per the ^ method
    [Authorize(Roles = "admin")] //only admins need access to all the information about the project
    [HttpGet("{boardGuid}")]
    public async Task<ActionResult<BoardDto>> GetBoardByGuid(Guid guid)
    {
        var boardId = await GuidHelpers.GetBoardIdByGuid(guid, _context);

        if (boardId == null)
            return NotFound("Board not found.");

        //fetching the project by ID and including active users
        var board = await _context.Boards
            .Where(p => p.Id == boardId && p.IsActive)
            .FirstOrDefaultAsync();

        if (board == null)
            return NotFound("Board not found or inactive.");

        //create the DTOs, including the profiles of all the users associated with the project
        var boardDto = new BoardDto
        {
            Guid = board.Guid,
            Name = board.Name,
            Description = board.Description,
        };

        return boardDto;
    }

    //retrieve boards for a specific project
    [HttpGet("project/{projectGuid}")]
    public async Task<ActionResult<IEnumerable<BoardDto>>> GetBoardsByProject(Guid projectGuid)
    {
        var projectId = await GuidHelpers.GetProjectIdByGuid(projectGuid, _context);
        if (projectId == null)
            return NotFound("Project not found.");

        // Fetch boards associated with the project
        var projectWithBoard = await _context.Projects
            .Where(p => p.IsActive && p.Id == projectId)
            .Include(p => p.Boards.Where(b => b.IsActive))
            .FirstOrDefaultAsync();

        var boards = projectWithBoard?.Boards;

        if (boards == null || !boards.Any())
            return Ok(new List<BoardDto>()); //returns an empty list if no boards are found
        //convert boards to DTOs
        var boardsDto = boards.Select(b => new BoardDto
        {
            Guid = b.Guid,
            Name = b.Name,
            Description = b.Description
        }).ToList();

        return Ok(boardsDto);
    }

    // POST: api/boards
    [Authorize(Roles = "admin")] //only admins can create boards
    [HttpPost("{projectGuid}")]
    public async Task<ActionResult<Board>> PostBoard(Guid projectGuid, [FromBody] BoardDto boardDto) //from body ensures that it takes the data directly from the json body
    {
        //getting the project that this board is being created in
        var projectId = await GuidHelpers.GetProjectIdByGuid(projectGuid, _context);
        var project = await _context.Projects
            .Where(p => p.IsActive && p.Id == projectId)
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

        //retrieving the user entity of the user that is creating the project
        var user = await _context.Siteusers.FindAsync(userId.Value);
        if (user == null)
            return NotFound("User entity not found.");

        //map DTO to entity
        var board = new Board
        {
            Guid = Guid.NewGuid(),
            Name = boardDto.Name,
            Description = boardDto.Description,
            CreatedById = user.Id,
            IsActive = true,
            Projects = new List<Project> { project }
        };

       

        _context.Boards.Add(board);
        await _context.SaveChangesAsync();

        // Return DTO for response
        var resultDto = new BoardDto
        {
            Guid = board.Guid,
            Name = board.Name,
            Description = board.Description,
        };
        return CreatedAtAction(nameof(GetBoardByGuid), new { boardGuid = board.Guid }, resultDto);
    }


    //update
    // PUT: api/boards/5
    [HttpPut("{guid}")]
    public async Task<IActionResult> PutBoard(Guid guid, BoardDto boardDto)
    {
        if (guid != boardDto.Guid)
            return BadRequest();

        var boardId = await GuidHelpers.GetBoardIdByGuid(guid, _context);
        if (boardId == null)
            return NotFound();

        //retrieve the current project from the database 
        var board = await _context.Boards
            .FirstOrDefaultAsync(b => b.Id == boardId && b.IsActive);

        if (board == null) return NotFound("Board not found");

        //update the basic fields
        board.Name = boardDto.Name;
        board.Description = boardDto.Description;

        await _context.SaveChangesAsync();
        return NoContent();
    }

    // DELETE: api/boards/5
    [Authorize(Roles = "admin")]
    [HttpDelete("{guid}")]
    public async Task<IActionResult> DeleteBoard(Guid guid)
    {
        if (guid == null)
            return Unauthorized("Missing project GUID in token");


        //convert guid to int ID
        var boardId = await GuidHelpers.GetBoardIdByGuid(guid, _context);
        if (boardId == null)
            return NotFound("Board not found.");

        var board = await _context.Boards
            .Where(b => b.Id == boardId && b.IsActive)
            .FirstOrDefaultAsync();

        if (board == null)
            return NotFound("Board not found.");

        //soft delete
        board.IsActive = false;

        await _context.SaveChangesAsync();
        return NoContent();
    }

    private bool BoardExists(int id)
    {
        return _context.Boards.Any(e => e.Id == id);
    }

}