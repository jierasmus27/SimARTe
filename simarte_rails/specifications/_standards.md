# Engineering Standards

## Architecture
- Controllers must be thin
- Business logic goes in service objects (/app/services)
- Use POROs for domain logic

## Rails
- Follow Rails conventions
- Use Devise for authentication
- Use strong params

## Testing
- Use RSpec
- Prefer request specs
- Cover edge cases explicitly

## Frontend
- Use TailwindCSS
- Use Stimulus for JS
- No inline JS
- Avoid using !important in css

## Code Rules
- No unused abstractions
- Prefer clarity over cleverness
- Keep methods small and focused
- Try to avoid duplication in backend and frontend code

## Anti-Patterns
- No fat controllers
- No logic in views
- No duplication of business logic
