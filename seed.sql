-- seed.sql
-- Task Manager: seed data
-- Run AFTER schema.sql, with: psql -U postgres -d task_manager -f seed.sql
-- Assumes a freshly-created schema (relies on SERIAL ids starting at 1).

-- 7 users (2 more than the minimum of 5): user 7 (Fatima) is intentionally
-- given zero assigned tasks, so query 3's LEFT JOIN has something real to
-- prove — an INNER JOIN would silently drop her.
INSERT INTO users (name, email) VALUES
  ('Hassan Khan',  'hassan@example.com'),
  ('Ayesha Malik', 'ayesha@example.com'),
  ('Bilal Ahmed',  'bilal@example.com'),
  ('Sara Iqbal',   'sara@example.com'),
  ('Usman Tariq',  'usman@example.com'),
  ('Zara Sheikh',  'zara@example.com'),
  ('Fatima Noor',  'fatima@example.com');

-- 4 projects (1 more than the minimum of 3): "Marketing Site" is
-- intentionally given zero tasks, for query 7 to find.
INSERT INTO projects (name, owner_id) VALUES
  ('Website Redesign', 1),
  ('Mobile App Launch', 2),
  ('Internal Tools',    3),
  ('Marketing Site',    1);

-- 15 tasks across projects 1-3 (project 4 gets none, on purpose).
-- due_date is relative to today (CURRENT_DATE +/- N) so "overdue" stays
-- correct regardless of when this file is run.
-- Overdue (status != done, due_date in the past): tasks 2, 4, 7, 13.
-- Unassigned (assignee_id NULL): tasks 3, 5, 9, 12.
-- Task 10: due date in the past but status = done — a deliberate edge
-- case, since a completed task should NOT count as overdue.
INSERT INTO tasks (title, description, status, priority, project_id, assignee_id, due_date) VALUES
  ('Design homepage mockup',        'Initial hero + layout concepts',        'done',        3, 1, 1,    CURRENT_DATE - 10),
  ('Implement navbar',              'Responsive nav with mobile menu',       'in_progress', 4, 1, 2,    CURRENT_DATE - 3),
  ('Write homepage copy',           'Hero, features, footer copy',           'todo',        2, 1, NULL, CURRENT_DATE + 5),
  ('Setup CI pipeline',             'Lint + test on every PR',               'todo',        5, 1, 3,    CURRENT_DATE - 2),
  ('Cross-browser testing',         'Safari, Firefox, Edge',                 'in_progress', 3, 1, NULL, CURRENT_DATE + 7),
  ('Design app icon',               'Final icon set, all resolutions',       'done',        2, 2, 2,    CURRENT_DATE - 15),
  ('Build login screen',            'Email + social auth',                   'in_progress', 4, 2, 4,    CURRENT_DATE - 1),
  ('Integrate push notifications',  'FCM setup for iOS + Android',           'todo',        3, 2, 2,    CURRENT_DATE + 10),
  ('App store listing copy',        'Title, description, keywords',          'todo',        1, 2, NULL, NULL),
  ('Beta testing round 1',          'TestFlight + Play Console beta',        'done',        5, 2, 2,    CURRENT_DATE - 4),
  ('Migrate database schema',       'Move legacy tables to new structure',   'done',        4, 3, 3,    CURRENT_DATE - 20),
  ('Build admin dashboard',         'User management + analytics view',      'todo',        2, 3, NULL, CURRENT_DATE + 12),
  ('Fix login bug',                 'Session expiring too early',            'in_progress', 5, 3, 5,    CURRENT_DATE - 6),
  ('Write API docs',                'OpenAPI spec + examples',               'todo',        1, 3, 6,    CURRENT_DATE + 8),
  ('Refactor auth module',          'Extract shared auth logic',             'done',        3, 3, 1,    CURRENT_DATE - 5);

-- 6 tags.
INSERT INTO tags (name) VALUES
  ('bug'),
  ('feature'),
  ('urgent'),
  ('backend'),
  ('frontend'),
  ('design');

-- 20 task-tag rows. Tags: 1=bug 2=feature 3=urgent 4=backend 5=frontend 6=design
-- Tasks 14 and 15 are deliberately left untagged, showing tagging is
-- optional (a task doesn't need to appear in task_tags at all).
INSERT INTO task_tags (task_id, tag_id) VALUES
  (1, 6), (1, 5),
  (2, 5), (2, 3),
  (3, 5),
  (4, 4), (4, 3),
  (5, 5),
  (6, 6),
  (7, 1), (7, 3),
  (8, 2), (8, 4),
  (9, 2),
  (10, 1), (10, 2),
  (11, 4),
  (12, 2), (12, 6),
  (13, 1);
