.PHONY: help build up down restart console server db-setup db-reset db-migrate test lint clean restart-services

# Default target
help:
	@echo "Available commands:"
	@echo "  make build          - Build Docker containers"
	@echo "  make up             - Start all services"
	@echo "  make down           - Stop all services"
	@echo "  make restart        - Restart all services (app job redis db)"
	@echo "  make console        - Open Rails console"
	@echo "  make server         - Start Rails server (and attach to app)"
	@echo "  make db-setup       - Create and setup database"
	@echo "  make db-reset       - Drop and recreate database"
	@echo "  make db-migrate     - Run database migrations"
	@echo "  make test           - Run test suite"
	@echo "  make lint           - Run RuboCop linter"
	@echo "  make logs           - Tail development logs"
	@echo "  make clean          - Remove all containers and volumes"

# Build containers
build:
	docker compose build

# Start all services
up:
	docker compose up -d

# Stop all services
down:
	docker compose down --remove-orphans

# Restart all services
restart-services:
	docker compose restart app job redis db

# Rails console
console:
	docker compose run --rm app bundle exec rails console

# Start Rails server and attach
server:
	docker compose up app

# Tail development logs
logs:
	tail -f log/development.log

# Attach to app service
attach:
	docker compose attach app

# Database setup
db-setup:
	docker compose run --rm app bundle exec rails db:create db:migrate

# Reset database
db-reset:
	docker compose run --rm app bundle exec rails db:drop db:create db:migrate

# Run migrations
db-migrate:
	docker compose run --rm app bundle exec rails db:migrate

# Run tests
test:
	docker compose run --rm app bundle exec rspec

# Run RuboCop
lint:
	docker compose run --rm app bundle exec rubocop

# Generate something (usage: make generate G="model User name:string")
generate:
	docker compose run --rm app bundle exec rails generate $(G)

# Run any Rails command (usage: make rails C="routes")
rails:
	docker compose run --rm app bundle exec rails $(C)

# Run any command (usage: make run C="db:migrate")
run:
	docker compose run --rm app $(C)

# Clean everything
clean:
	docker compose down --volumes --remove-orphans
	docker system prune -f

# Install gems
bundle:
	docker compose run --rm app bundle install
