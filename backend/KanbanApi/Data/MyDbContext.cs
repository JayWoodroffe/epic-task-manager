using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql.Scaffolding.Internal;
using KanbanApi.Models; 
namespace KanbanApi.Data;


public partial class MyDbContext : DbContext
{
    public MyDbContext()
    {
    }

    public MyDbContext(DbContextOptions<MyDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Board> Boards { get; set; }

    public virtual DbSet<List> Lists { get; set; }

    public virtual DbSet<Project> Projects { get; set; }

    public virtual DbSet<Siteuser> Siteusers { get; set; }

    public virtual DbSet<Status> Statuses { get; set; }

    public virtual DbSet<KanbanApi.Models.Task> Tasks { get; set; }

    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .UseCollation("utf8mb4_0900_ai_ci")
            .HasCharSet("utf8mb4");

        modelBuilder.Entity<Board>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("board");

            entity.HasIndex(e => e.CreatedById, "CreatedById");

            entity.HasIndex(e => e.UpdatedById, "UpdatedById");

            entity.Property(e => e.CreatedOn)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("datetime");
            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.IsActive).HasDefaultValueSql("'1'");
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.UpdatedOn).HasColumnType("datetime");

            entity.HasOne(d => d.CreatedBy).WithMany(p => p.BoardCreatedBies)
                .HasForeignKey(d => d.CreatedById)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("board_ibfk_1");

            entity.HasOne(d => d.UpdatedBy).WithMany(p => p.BoardUpdatedBies)
                .HasForeignKey(d => d.UpdatedById)
                .HasConstraintName("board_ibfk_2");
        });

        modelBuilder.Entity<List>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("list");

            entity.HasIndex(e => e.BoardId, "BoardId");

            entity.HasIndex(e => e.CreatedById, "CreatedById");

            entity.HasIndex(e => e.StatusId, "StatusId");

            entity.HasIndex(e => e.UpdatedById, "UpdatedById");

            entity.Property(e => e.CreatedOn)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("datetime");
            entity.Property(e => e.IsActive).HasDefaultValueSql("'1'");
            entity.Property(e => e.Name)
                .HasMaxLength(255)
                .HasColumnName("name");
            entity.Property(e => e.UpdatedOn).HasColumnType("datetime");

            entity.HasOne(d => d.Board).WithMany(p => p.Lists)
                .HasForeignKey(d => d.BoardId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("list_ibfk_1");

            entity.HasOne(d => d.CreatedBy).WithMany(p => p.ListCreatedBies)
                .HasForeignKey(d => d.CreatedById)
                .HasConstraintName("list_ibfk_3");

            entity.HasOne(d => d.Status).WithMany(p => p.Lists)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("list_ibfk_2");

            entity.HasOne(d => d.UpdatedBy).WithMany(p => p.ListUpdatedBies)
                .HasForeignKey(d => d.UpdatedById)
                .HasConstraintName("list_ibfk_4");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("project");

            entity.HasIndex(e => e.CreatedById, "CreatedById");

            entity.HasIndex(e => e.UpdatedById, "UpdatedById");

            entity.Property(e => e.CreatedOn)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("datetime");
            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.IsActive).HasDefaultValueSql("'1'");
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.UpdatedOn).HasColumnType("datetime");

            entity.HasOne(d => d.CreatedBy).WithMany(p => p.ProjectCreatedBies)
                .HasForeignKey(d => d.CreatedById)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("project_ibfk_1");

            entity.HasOne(d => d.UpdatedBy).WithMany(p => p.ProjectUpdatedBies)
                .HasForeignKey(d => d.UpdatedById)
                .HasConstraintName("project_ibfk_2");

            entity.HasMany(d => d.Boards).WithMany(p => p.Projects)
                .UsingEntity<Dictionary<string, object>>(
                    "Projectboard",
                    r => r.HasOne<Board>().WithMany()
                        .HasForeignKey("BoardId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("projectboard_ibfk_2"),
                    l => l.HasOne<Project>().WithMany()
                        .HasForeignKey("ProjectId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("projectboard_ibfk_1"),
                    j =>
                    {
                        j.HasKey("ProjectId", "BoardId")
                            .HasName("PRIMARY")
                            .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });
                        j.ToTable("projectboard");
                        j.HasIndex(new[] { "BoardId" }, "BoardId");
                    });

            entity.HasMany(d => d.Users).WithMany(p => p.Projects)
                .UsingEntity<Dictionary<string, object>>(
                    "Userproject",
                    r => r.HasOne<Siteuser>().WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("userproject_ibfk_2"),
                    l => l.HasOne<Project>().WithMany()
                        .HasForeignKey("ProjectId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("userproject_ibfk_1"),
                    j =>
                    {
                        j.HasKey("ProjectId", "UserId")
                            .HasName("PRIMARY")
                            .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });
                        j.ToTable("userproject");
                        j.HasIndex(new[] { "UserId" }, "UserId");
                    });
        });

        modelBuilder.Entity<Siteuser>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("siteuser");

            entity.HasIndex(e => e.Email, "Email").IsUnique();

            entity.Property(e => e.CreatedOn)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("datetime");
            entity.Property(e => e.FullName).HasMaxLength(255);
            entity.Property(e => e.IsActive)
                .IsRequired()
                .HasDefaultValueSql("'1'");
            entity.Property(e => e.PasswordHash).HasColumnType("text");
            entity.Property(e => e.Role)
                .HasDefaultValueSql("'user'")
                .HasColumnType("enum('admin','user')");
            entity.Property(e => e.UpdatedOn).HasColumnType("datetime");
        });

        modelBuilder.Entity<Status>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("status");

            entity.HasIndex(e => e.CreatedById, "CreatedById");

            entity.HasIndex(e => e.UpdatedById, "UpdatedById");

            entity.Property(e => e.Color).HasMaxLength(20);
            entity.Property(e => e.CreatedOn)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("datetime");
            entity.Property(e => e.IsActive).HasDefaultValueSql("'1'");
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.UpdatedOn).HasColumnType("datetime");

            entity.HasOne(d => d.CreatedBy).WithMany(p => p.StatusCreatedBies)
                .HasForeignKey(d => d.CreatedById)
                .HasConstraintName("status_ibfk_1");

            entity.HasOne(d => d.UpdatedBy).WithMany(p => p.StatusUpdatedBies)
                .HasForeignKey(d => d.UpdatedById)
                .HasConstraintName("status_ibfk_2");
        });

        modelBuilder.Entity<KanbanApi.Models.Task>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("task");

            entity.HasIndex(e => e.CreatedById, "CreatedById");

            entity.HasIndex(e => e.ListId, "ListId");

            entity.HasIndex(e => e.UpdatedById, "UpdatedById");

            entity.Property(e => e.CreatedOn)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("datetime");
            entity.Property(e => e.IsActive).HasDefaultValueSql("'1'");
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.UpdatedOn).HasColumnType("datetime");

            entity.HasOne(d => d.CreatedBy).WithMany(p => p.TaskCreatedBies)
                .HasForeignKey(d => d.CreatedById)
                .HasConstraintName("task_ibfk_4");

            entity.HasOne(d => d.List).WithMany(p => p.Tasks)
                .HasForeignKey(d => d.ListId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("task_ibfk_3");

            entity.HasOne(d => d.UpdatedBy).WithMany(p => p.TaskUpdatedBies)
                .HasForeignKey(d => d.UpdatedById)
                .HasConstraintName("task_ibfk_5");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
