# Docker Rails Development Environment

This project is configured to work with VS Code Dev Containers for a consistent development environment.

## 🚀 Getting Started

### Prerequisites

- [Docker](https://www.docker.com/get-started)
- [VS Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Setup

1. **Open in Dev Container**:
   - Open VS Code
   - Open the project folder
   - Click on the popup "Reopen in Container" or
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) → "Dev Containers: Reopen in Container"

2. **Wait for Setup**:
   - The container will build automatically
   - Dependencies will be installed
   - Database will be set up

3. **Start Development**:
   ```bash
   # Start Rails server
   bundle exec rails server

   # Run tests
   bundle exec rspec

   # Run system tests
   bundle exec rspec spec/system
   ```

## 🔧 Services Included

- **Ruby 3.3.8** - Main application runtime
- **PostgreSQL 15** - Database server
- **Redis 7** - Caching and session store
- **Node.js 20** - For asset pipeline
- **Selenium Chrome** - For system tests
- **Gemstash** - RubyGems cache and private gem server
- **rails-test** - Dedicated test environment service

## 📁 Project Structure

```
.devcontainer/
├── devcontainer.json    # VS Code Dev Container configuration
├── docker-compose.yml   # Docker services configuration
├── Dockerfile          # Development container image
├── setup.sh            # Setup script
└── README.md           # This file
```

## 🛠️ Development Features

### VS Code Extensions

The dev container automatically installs:
- Ruby language support
- Solargraph (Ruby language server)
- RuboCop (Ruby linter)
- Test adapters
- Git integration
- GitHub Copilot (if available)

### Database Access

- **PostgreSQL**: Available on port 5432
- **Connection**: `postgresql://postgres:password@localhost:5432/docker_rails_development`
- **GUI Tools**: Use any PostgreSQL client to connect

### Testing

- **RSpec**: Full test suite with request and system specs
- **Capybara**: System tests with screenshot support
- **Selenium**: Browser automation for system tests
- **Dedicated Test Service**: `rails-test` service for isolated testing
- **Chrome**: Headless browser for testing

## 🐛 Troubleshooting

### Container Won't Start

1. **Check Docker**: Ensure Docker is running
2. **Rebuild Container**: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"
3. **Check Logs**: View container logs in VS Code terminal

### Database Issues

1. **Reset Database**:
   ```bash
   bundle exec rails db:drop
   bundle exec rails db:create
   bundle exec rails db:migrate
   ```

2. **PostgreSQL Connection**:
   - Ensure the postgres service is running
   - Check `docker-compose logs postgres`

### Performance Issues

1. **Volume Mounts**: Ensure volumes are properly mounted
2. **Memory**: Increase Docker memory allocation
3. **Cache**: Clear bundle cache: `bundle clean --force`

## 📊 Available Commands

### Development Commands (Inside Container)
```bash
# Application
bundle exec rails server          # Start Rails server
bundle exec rails console         # Rails console
bundle exec rails generate        # Rails generators

# Database
bundle exec rails db:create       # Create database
bundle exec rails db:migrate      # Run migrations
bundle exec rails db:seed         # Seed database
bundle exec rails db:reset        # Reset database

# Testing
bundle exec rspec                 # Run all tests
bundle exec rspec spec/system     # Run system tests
bundle exec rspec spec/requests   # Run request tests

# Code Quality
bundle exec rubocop               # Run RuboCop linter
bundle exec rubocop -a            # Auto-fix issues
```

### Docker Commands (From Host)
```bash
# Start all services
docker-compose up -d

# Run tests automatically
docker-compose up rails-test

# Interactive shell
docker-compose exec rails bash

# Test-specific commands
docker-compose exec rails-test bash
docker-compose run --rm rails-test bundle exec rspec
docker-compose run --rm rails-test bundle exec rspec spec/requests/

# Stop services
docker-compose down
```

## 🌐 Port Forwarding

The dev container automatically forwards these ports:
- **3000**: Rails server
- **5432**: PostgreSQL
- **9292**: Gemstash server

## 🗃️ Gemstash Integration

Your environment includes [Gemstash](https://github.com/rubygems/gemstash), a RubyGems.org cache and private gem server that provides:

### Benefits
- **Faster gem installations** - Cached gems install instantly
- **Offline development** - Continue working without internet (for cached gems)
- **Bandwidth savings** - Download gems only once, reuse across containers
- **Private gem hosting** - Host internal gems securely

### Usage
Gemstash is automatically configured for your Rails containers. All `bundle install` commands will:
1. First check Gemstash cache
2. Fall back to rubygems.org if needed (with 3-second timeout)
3. Cache downloaded gems for future use

### Manual Configuration
If you need to configure Bundler manually:
```bash
# Use Gemstash as mirror
bundle config mirror.https://rubygems.org http://localhost:9292

# Set fallback timeout
bundle config mirror.https://rubygems.org.fallback_timeout 3

# Remove mirror configuration
bundle config --delete mirror.https://rubygems.org
```

### Management
```bash
# Start Gemstash separately
cd .devcontainer && ./gemstash-setup.sh

# Check Gemstash status
curl http://localhost:9292

# View Gemstash logs
docker-compose logs gemstash
```

## 🚀 Production Deployment

This setup is for development only. For production:
1. Use the main `Dockerfile` in the project root
2. Configure production database
3. Set up proper environment variables
4. Use a production-ready web server

## 📝 Notes

- The development environment uses PostgreSQL instead of SQLite
- All gems and node modules are cached in Docker volumes
- System tests run in headless Chrome
- Screenshots are saved to `tmp/capybara/` on test failures 