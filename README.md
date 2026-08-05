# Task Manager — SQL

A relational schema, seed data, and eight queries for a Task Management
system, built in raw PostgreSQL.

## Setup

Requires PostgreSQL running locally (see below for Docker).

```bash
docker run --name task-manager-db -e POSTGRES_PASSWORD=devpassword -e POSTGRES_DB=task_manager -p 5432:5432 -d postgres:16
```

## Run

```bash
Get-Content schema.sql | docker exec -i task-manager-db psql -U postgres -d task_manager
Get-Content seed.sql | docker exec -i task-manager-db psql -U postgres -d task_manager
Get-Content queries.sql | docker exec -i task-manager-db psql -U postgres -d task_manager
```

## Files

- `schema.sql` — five tables: users, projects, tasks, tags, task_tags
- `seed.sql` — realistic seed data (7 users, 4 projects, 15 tasks, 6 tags, 20 task_tags)
- `queries.sql` — eight queries answering real questions about the data