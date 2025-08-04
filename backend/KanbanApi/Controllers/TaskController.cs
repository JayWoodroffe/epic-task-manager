using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KanbanApi.Models;  
using KanbanApi.Data;    
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using KanbanApi.Helpers;

namespace KanbanApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TasksController : ControllerBase
    {
        private readonly MyDbContext _context;

        public TasksController(MyDbContext context)
        {
            _context = context;
        }

        // GET: api/tasks
        [Authorize(Roles = "admin")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TaskDto>>> GetTasks()
        {
            var tasks = await _context.Tasks.Where(t => t.IsActive).ToListAsync();
            var taskDtos = tasks.Select(async t => new TaskDto
            {
                Guid = t.Guid,
                Name = t.Name,
                Position = t.Position,
                ListId = _context.Lists.Where(l => l.Id == t.ListId && l.IsActive).Select(l => l.Guid).FirstOrDefault(),
            });
            return Ok(taskDtos);
        }

        // GET: api/tasks/5
        [HttpGet("{guid}")]
        public async Task<ActionResult<TaskDto>> GetTaskByGuid(Guid guid)
        {

            var taskId = await GuidHelpers.GetTaskIdByGuid(guid, _context);

            if (taskId == null)
                return NotFound("Task not found.");

            //fetching the task by ID
            var task = await _context.Tasks
                .Where(t => t.Id == taskId && t.IsActive)
                .FirstOrDefaultAsync();

            if (task == null)
                return NotFound("Task not found or inactive.");

            //create the DTO
            var taskDto = new TaskDto
            {
                Guid = task.Guid,
                Name = task.Name,
                Position = task.Position,
            };

            return taskDto;
        }

        //create a new task on a specific list
        // POST: api/tasks
        [HttpPost]
        public async Task<ActionResult<TaskDto>> PostTask(Guid listGuid, [FromBody] TaskDto taskDto)
        {
            //getting the list that this task is being created in
            var listId = await GuidHelpers.GetListIdByGuid(listGuid, _context);
            if (listId == null)
                return NotFound("List not found.");
            //retrieving the list entity
            var list = await _context.Lists
                .Where(l => l.IsActive && l.Id == listId)
                .FirstOrDefaultAsync();
            if (list == null)
                return NotFound("List not found or inactive.");

            //getting the user that is creating the task
            var userGuidString = User.FindFirst("guid")?.Value;
            if (!Guid.TryParse(userGuidString, out var userGuid))
            {
                return Unauthorized("Invalid user GUID in token");
            }

            //convert user guid to int ID
            var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
            if (userId == null)
                return NotFound("User not found.");

            //retrieving the user entity of the user that is creating the task
            var user = await _context.Siteusers.FindAsync(userId.Value);
            if (user == null)
                return NotFound("User entity not found.");

            //map DTO to entity
            var task = new KanbanApi.Models.Task
            {
                Guid = Guid.NewGuid(),
                Name = taskDto.Name,
                Position = taskDto.Position,
                ListId = list.Id,
                CreatedById = user.Id,
                IsActive = true,
                CreatedOn = DateTime.UtcNow,
            };

            _context.Tasks.Add(task);
            await _context.SaveChangesAsync();

            var resultsDto = new TaskDto
            {
                Guid = task.Guid,
                Name = task.Name,
                Position = task.Position,
                ListId = listGuid, //returning the list GUID
            };

           return CreatedAtAction(nameof(GetTaskByGuid), new { guid = task.Guid }, resultsDto);
        }

        // PUT: api/tasks/5
        //update a task
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTask(Guid guid, TaskDto taskDto)
        {
            if (guid != taskDto.Guid)
                return BadRequest();

            //getting the user that is updating the task
            var userGuidString = User.FindFirst("guid")?.Value;
            if (!Guid.TryParse(userGuidString, out var userGuid))
            {
                return Unauthorized("Invalid user GUID in token");
            }

            //convert user guid to int ID
            var userId = await GuidHelpers.GetUserIdByGuid(userGuid, _context);
            if (userId == null)
                return NotFound("User not found.");

            //retrieving the user entity of the user that is updating the task
            var user = await _context.Siteusers.FindAsync(userId.Value);
            if (user == null)
                return NotFound("User entity not found.");


            var taskId = await GuidHelpers.GetTaskIdByGuid(guid, _context);
            if (taskId == null)
                return NotFound("Task not found.");

            //retrieve the current task from the database
            var task = await _context.Tasks
                .Where(t => t.Id == taskId && t.IsActive)
                .FirstOrDefaultAsync();

            if (task == null) 
                return NotFound("Task not found or inactive.");

            //update the basic fields
            task.Name = taskDto.Name;
            task.Position = taskDto.Position;
            task.UpdatedBy = user;
            task.UpdatedOn = DateTime.UtcNow;
            // Convert nullable int? to int with null check
            var listIdNullable = await GuidHelpers.GetListIdByGuid(taskDto.ListId, _context);
            if (listIdNullable == null)
                return NotFound("List not found.");
            task.ListId = listIdNullable.Value;


            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/tasks/5
        [HttpDelete("{guid}")]
        public async Task<IActionResult> DeleteTask(Guid guid)
        {
            if (guid == null)
                return BadRequest("Task GUID is required.");

            //convert the GUID to an ID
            var taskId = await GuidHelpers.GetTaskIdByGuid(guid, _context);
            if (taskId == null)
                return NotFound("Task not found.");

            var task = await _context.Tasks
                .Where(t => t.Id == taskId && t.IsActive)
                .FirstOrDefaultAsync();

            if (task == null)
                return NotFound("Task not found or inactive.");

            //soft delete the task
            task.IsActive = false;

            await _context.SaveChangesAsync();
            return NoContent();

        }

        private bool TaskExists(int id)
        {
            return _context.Tasks.Any(e => e.Id == id);
        }


        //move tasks between lists
        [HttpPut("{taskGuid}/move")]
        public async Task<IActionResult> MoveTask(Guid taskGuid, [FromBody] TaskMoveDto moveDto)
        {
            var taskId = await GuidHelpers.GetTaskIdByGuid(taskGuid, _context);
            var task = await _context.Tasks.FirstOrDefaultAsync(t => t.Id == taskId && t.IsActive);
            if (task == null) return NotFound("Task not found.");

            var listId = await GuidHelpers.GetListIdByGuid(moveDto.NewListId, _context);
            var newList = await _context.Lists.FirstOrDefaultAsync(l => l.Id == listId);
            if (newList == null) return NotFound("List not found.");

            task.ListId = newList.Id;
            task.Position = moveDto.NewOrder;

            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}

    
