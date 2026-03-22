# Finance App

A Ruby on Rails 7 application for managing personal finances, built with Docker and PostgreSQL.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

```bash
# Build and start the application
docker compose build
docker compose up -d

# Setup the database
docker compose run --rm app bundle exec rails db:create db:migrate

# View logs
tail -f log/development.log
```

The application will be available at [http://localhost:3000](http://localhost:3000)

## Docker Commands

### Restart services
```bash
docker compose restart app job redis db
```

### Access Rails console
```bash
docker compose run --rm app bundle exec rails console
```

### View logs
```bash
tail -f log/development.log
```

### Attach to app service
```bash
docker compose attach app
```

### Run RSpec
```bash
docker compose run --rm app bundle exec rspec
```

### Run RuboCop
```bash
docker compose run --rm app bundle exec rubocop
```

### Run any command
```bash
docker compose run --rm app db:migrate
docker compose run --rm app bundle exec rails routes
docker compose run --rm app bundle exec rails generate model User
```

## Using Make (Optional)

```bash
# View all available commands
make help

# Common tasks
make build              # Build containers
make up                 # Start all services
make down               # Stop all services
make restart-services   # Restart all services
make console            # Rails console
make db-migrate         # Run migrations
make test               # Run tests
make lint               # Run RuboCop
make logs               # Tail development logs
make clean              # Remove all containers and volumes
```

## Database Management

```bash
# Create and setup database
docker compose run --rm app bundle exec rails db:create db:migrate

# Reset database (drop + create + migrate)
docker compose run --rm app bundle exec rails db:drop db:create db:migrate

# Run migrations
docker compose run --rm app bundle exec rails db:migrate

# Seed database
docker compose run --rm app bundle exec rails db:seed
```

## Testing

```bash
# Run all tests
docker compose run --rm app bundle exec rspec

# Run specific test file
docker compose run --rm app bundle exec rspec spec/models/user_spec.rb

# Run specific test line
docker compose run --rm app bundle exec rspec spec/models/user_spec.rb:15
```

## Linting

```bash
# Run RuboCop
docker compose run --rm app bundle exec rubocop

# Auto-fix issues
docker compose run --rm app bundle exec rubocop -a
```

## Services

- **app**: Rails 7 application (port 3000)
- **db**: PostgreSQL 15
- **redis**: Redis 7.0 for caching and background jobs
- **job**: Sidekiq background job processor

## Cleaning Up

```bash
# Stop containers and remove orphaned containers
docker compose down --remove-orphans

# Remove everything including volumes
docker compose down --volumes --remove-orphans
```

## Troubleshooting

### Container won't start
```bash
# View logs
docker compose logs app

# Rebuild container
docker compose build --no-cache app
```

### Database connection issues
```bash
# Restart database
docker compose restart db

# Recreate database
docker compose run --rm app bundle exec rails db:drop db:create db:migrate
```

### Orphaned containers warning
```bash
# Clean up orphan containers
docker compose down --remove-orphans
```
