# Agent / dev environment notes

## Docker Compose

This project runs the Rails app through **Docker Compose**. Prefer the **`web`** service for any Ruby or Node tooling so Bundler, gems, and `node_modules` match the container environment (volume `bundle_data` and `/app` workspace).

Use **`exec`** when the stack is already up; use **`run --rm`** for one-off commands when it is not.

Examples:

```bash
docker compose exec web bundle install
docker compose exec web bundle exec rubocop
docker compose exec web bundle exec rails db:migrate
docker compose exec web npm install
docker compose exec web npm run lint:js
docker compose exec web npm run test:js
```

One-off (no running `web` container):

```bash
docker compose run --rm web bundle install
docker compose run --rm web npm run lint:js
```

Adjust service name if your `docker-compose.yml` renames `web`.

## GraphQL / Auth0

`/graphql` expects `Authorization: Bearer <Auth0 access token>` (RS256, API audience). Set **`AUTH0_DOMAIN`** (tenant host) and **`AUTH0_AUDIENCE`** (Auth0 API identifier), or add **`auth0.domain`** / **`auth0.audience`** via `bin/rails credentials:edit`. See `simarte_rails/openspec/specs/auth0-graphql-jwt.md` and `simarte_rails/.env.example`.
