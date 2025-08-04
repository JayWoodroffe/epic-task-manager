using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KanbanApi.Models;
using KanbanApi.Services;
using KanbanApi.Helpers;
using KanbanApi.Data;


[ApiController]
[Route("api/[controller]")]
public class  AuthController:ControllerBase
{
    private readonly MyDbContext _context;
    private readonly TokenService _tokenService;

    public AuthController(MyDbContext context, TokenService tokenService)
    {
        _context = context;
        _tokenService = tokenService;
	}

	[HttpGet("hash-password")]
	public IActionResult HashPassword([FromQuery] string password)
	{
		var hash = PasswordHasher.HashPassword(password);
		return Ok(new { password, hash });
	}

	[HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request)
    {
        var user = await _context.Siteusers
            .FirstOrDefaultAsync(u => u.Email == request.Email);

        if(user == null ||!PasswordHasher.VerifyPassword(request.Password, user.PasswordHash))
        {
            return Unauthorized(new { message = "Invalid email or password" });
		}

        var token = _tokenService.CreateToken(user);

        return Ok(new { token });
	}

    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterRequest request)
    {
        if (await _context.Siteusers.AnyAsync(u => u.Email == request.Email))
        {
            return BadRequest(new { message = "Email already in use" });
        }

        if(request.Password != request.ConfirmPassword)
        {
            return BadRequest(new { message = "Passwords do not match" });
        }
        if (string.IsNullOrWhiteSpace(request.FullName))
        {
            return BadRequest(new { message = "Name is required" });
        }
        var user = new Siteuser
        {
            Guid = Guid.NewGuid(),
            Email = request.Email,
            PasswordHash = PasswordHasher.HashPassword(request.Password),
            FullName = request.FullName,
        };

        _context.Siteusers.Add(user);
        await _context.SaveChangesAsync();
        var token = _tokenService.CreateToken(user);
        return Ok(new { token });
    }
}
