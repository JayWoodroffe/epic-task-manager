using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.Infrastructure;
using KanbanApi.Data;
using KanbanApi.Services;

using Microsoft.AspNetCore.Mvc;
var builder = WebApplication.CreateBuilder(args);

// Add user secrets 
builder.Configuration.AddUserSecrets<Program>();

// Connection string from user secrets
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<MyDbContext>(options =>
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));
builder.Services.AddScoped<TokenService>();


// Add services
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.Preserve;
        options.JsonSerializerOptions.WriteIndented = true;
    });
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//enabling cross-origin resource sharing (CORS) to allow requests from the Flutter app
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterApp", builder =>
    {
        builder
            .WithOrigins("http://localhost:3000", "http://localhost:5285", "http://192.168.1.54") // your frontend URLs
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials(); // optional if using cookies
    });
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFlutterApp"); // Use the CORS policy
//app.Urls.Add(); //configure api to listen on the LAN

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


app.MapControllers();
app.Run("http://0.0.0.0:5285");
