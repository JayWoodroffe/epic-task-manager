using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.Infrastructure;
using KanbanApi.Data;

var builder = WebApplication.CreateBuilder(args);

// Add user secrets 
builder.Configuration.AddUserSecrets<Program>();

// Connection string from user secrets
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<MyDbContext>(options =>
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));

// Add services
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

// Map API endpoints here for each resource (tasks, lists, etc.)
// app.MapGet("/tasks", ... );
app.MapGet("/tasks", async (MyDbContext db) =>
{
    var tasks = await db.Tasks.ToListAsync();
    return tasks;
});

app.MapGet("/users/{userId}/projects", async)

app.Run();
