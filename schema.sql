-- schema.sql
-- Task Manager: raw SQL schema
-- Run with: psql -U postgres -d task_manager -f schema.sql
-- (or, via Docker: Get-Content schema.sql | docker exec -i task-manager-db psql -U postgres -d task_manager)

-- Drop tables first (in dependency order) so this file can be re-run
-- cleanly against a database that already has these tables.
DROP TABLE IF EXISTS task_tags;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS users;

-- users: no foreign keys, the root of every relationship below.
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);

-- projects: belongs to one owner (users). Deleting a user deletes
-- their projects too — a project without an owner doesn't make sense
-- in this domain.
CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  owner_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT now()
);

-- tasks: belongs to one project (required), optionally assigned to one
-- user. Deleting a project deletes its tasks (they can't exist without
-- it). Deleting an assigned user only unassigns the task, it doesn't
-- delete it.
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'todo'
    CHECK (status IN ('todo', 'in_progress', 'done')),
  priority INTEGER CHECK (priority BETWEEN 1 AND 5),
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  assignee_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  due_date DATE,
  created_at TIMESTAMP DEFAULT now()
);

-- tags: a flat, reusable set of labels.
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

-- task_tags: many-to-many join table between tasks and tags. Composite
-- primary key means a given (task, tag) pair can only exist once — no
-- duplicate tagging. Both sides cascade: deleting a task or a tag
-- removes the association rows that reference it.
CREATE TABLE task_tags (
  task_id INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  tag_id INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (task_id, tag_id)
);
