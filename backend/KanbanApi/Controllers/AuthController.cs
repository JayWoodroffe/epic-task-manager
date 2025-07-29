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
}
