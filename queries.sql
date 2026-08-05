-- queries.sql
-- Task Manager: the eight required queries
-- Run with: psql -U postgres -d task_manager -f queries.sql
-- (assumes schema.sql and seed.sql have already been run)

-- 1. All tasks for a given project, ordered by due date ascending with
-- NULLs last. Project 1 (Website Redesign) used as the example.
SELECT id, title, status, priority, due_date
FROM tasks
WHERE project_id = 1
ORDER BY due_date ASC NULLS LAST;

-- 2. The count of tasks per status.
SELECT status, count(*) AS task_count
FROM tasks
GROUP BY status
ORDER BY status;

-- 3. Every user with their number of assigned tasks. Uses a LEFT JOIN
-- (not INNER JOIN) specifically so users with zero assigned tasks still
-- appear in the result, with a count of 0, instead of being silently
-- dropped.
SELECT u.id, u.name, count(t.id) AS assigned_task_count
FROM users u
LEFT JOIN tasks t ON t.assignee_id = u.id
GROUP BY u.id, u.name
ORDER BY u.id;

-- 4. All tasks carrying a given tag name, joined through task_tags.
-- Tag name 'urgent' used as the example.
SELECT t.id, t.title, t.status, t.priority
FROM tasks t
JOIN task_tags tt ON tt.task_id = t.id
JOIN tags tg ON tg.id = tt.tag_id
WHERE tg.name = 'urgent';

-- 5. Overdue tasks — due date before today and status not done — with
-- the assignee's name. LEFT JOIN to users so an unassigned overdue task
-- would still appear (with a NULL assignee name) rather than being
-- dropped by an INNER JOIN.
SELECT t.id, t.title, t.due_date, t.status, u.name AS assignee_name
FROM tasks t
LEFT JOIN users u ON u.id = t.assignee_id
WHERE t.due_date < CURRENT_DATE
  AND t.status != 'done'
ORDER BY t.due_date ASC;

-- 6. The top three users by number of completed tasks.
SELECT u.id, u.name, count(t.id) AS completed_task_count
FROM users u
JOIN tasks t ON t.assignee_id = u.id AND t.status = 'done'
GROUP BY u.id, u.name
ORDER BY completed_task_count DESC
LIMIT 3;

-- 7. Projects that have no tasks at all. LEFT JOIN from projects to
-- tasks, then filter to rows where the join found nothing.
SELECT p.id, p.name
FROM projects p
LEFT JOIN tasks t ON t.project_id = p.id
WHERE t.id IS NULL;

-- 8. The average number of tags per task. LEFT JOIN so tasks with zero
-- tags are still counted (as 0) in the average, not excluded from it.
SELECT round(avg(tag_count), 2) AS avg_tags_per_task
FROM (
  SELECT t.id, count(tt.tag_id) AS tag_count
  FROM tasks t
  LEFT JOIN task_tags tt ON tt.task_id = t.id
  GROUP BY t.id
) per_task_counts;
