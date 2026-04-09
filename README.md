# SimARTe

Web application for managing users, service subscriptions, and admin workflows. The app is a **Rails 8** monolith with **Hotwire** (Turbo + Stimulus), **ViewComponent**, **Tailwind CSS**, and **Devise** authentication.

## Tech stack

| Area | Choice |
|------|--------|
| Framework | Ruby on Rails ~> 8.1 |
| Database | PostgreSQL 16 |
| Background jobs | Sidekiq (Redis) |
| Frontend | Importmap, Turbo, Stimulus, Tailwind (`tailwindcss-rails`), Propshaft |
| UI | ViewComponent |
| Auth | Devise |

Services defined in Docker Compose: **web** (Rails via `bin/dev`), **db** (Postgres), **redis**, **sidekiq**.

## Repository layout

```
SimARTe/
├── docker-compose.yml    # Postgres, Redis, web, Sidekiq
└── simarte_rails/        # Rails application (root for local non-Docker work)
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/)
- (Optional) Ruby 3.4+ and PostgreSQL / Redis if you run the app without Docker

## Quick start (Docker)

1. **Clone** the repository.

2. **Configure environment variables** used by Compose (create a `.env` in the repo root or export them). Example values:

   ```bash
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=postgres
   POSTGRES_DB=simarte_development
   DATABASE_HOST=db
   DATABASE_USER=postgres
   DATABASE_PASSWORD=postgres
   REDIS_URL=redis://redis:6379/0
   ```

   Align these with `config/database.yml` and any Redis URL your app expects.

3. **Build and start** services:

   ```bash
   docker compose up --build
   ```

4. **Prepare the database** (first run, or after schema changes):

   ```bash
   docker compose exec web bin/rails db:prepare
   ```

   Optionally load seed data:

   ```bash
   docker compose exec web bin/rails db:seed
   ```

5. Open **http://localhost:3000** in your browser.

The `web` service runs **`bin/dev`** (Foreman + `Procfile.dev`), which starts the Rails server in the container.

## Development without Docker

From `simarte_rails/`:

```bash
bundle install
# configure config/database.yml for local Postgres if needed
bin/rails db:prepare
bin/dev
```

Ensure Redis is running if you use Sidekiq or features that depend on it.

## Tests

```bash
# Inside Docker
docker compose exec web bin/rails test

# Locally (from simarte_rails/)
bin/rails test
```

## Useful commands

| Task | Command |
|------|---------|
| Rails console | `docker compose exec web bin/rails console` |
| Migrations | `docker compose exec web bin/rails db:migrate` |
| Sidekiq UI | Mounted at `/sidekiq` (configure access appropriately in production) |

## Health check

`GET /up` returns the Rails health check (useful for load balancers and uptime probes).

## License

Add your license here (e.g. MIT, proprietary).

## Contributing

Add your branch naming, PR, and code style expectations here if applicable.
