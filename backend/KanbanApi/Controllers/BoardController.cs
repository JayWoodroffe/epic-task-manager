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
    // GET: api/board
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


}