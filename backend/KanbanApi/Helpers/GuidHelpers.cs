using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using KanbanApi.Data;

//converting the front facing guid to the incremental ids used for foreign keys
namespace KanbanApi.Helpers
{
    public static class GuidHelpers
    {
        public static async Task<int?> GetUserIdByGuid(Guid userGuid, MyDbContext db)
        {
            var user = await db.Siteusers.FirstOrDefaultAsync(u => u.Guid == userGuid);
            return user?.Id;
        }

        public static async Task<int?> GetProjectIdByGuid(Guid projectGuid, MyDbContext db)
        {
            var project = await db.Projects.FirstOrDefaultAsync(p => p.Guid == projectGuid);
            return project?.Id;
        }

        public static async Task<int?> GetBoardIdByGuid(Guid boardGuid, MyDbContext db)
        {
            var board = await db.Boards.FirstOrDefaultAsync(b => b.Guid == boardGuid);
            return board?.Id;
        }

        public static async Task<int?> GetListIdByGuid(Guid listGuid, MyDbContext db)
        {
            var list = await db.Lists.FirstOrDefaultAsync(l => l.Guid == listGuid);
            return list?.Id;
        }

        public static async Task<int?> GetTaskIdByGuid(Guid taskGuid, MyDbContext db)
        {
            var task = await db.Tasks.FirstOrDefaultAsync(t => t.Guid == taskGuid);
            return task?.Id;
        }
    }
}