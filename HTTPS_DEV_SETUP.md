# HTTPS Development Setup for care.lvh.me

## 🔐 SSL Configuration

Your Rails application is configured to run with HTTPS for both development and testing.

### Key Features:
- **Self-signed SSL certificates** automatically generated
- **Persistent SSL certificates** via Docker volume
- **HTTPS enforcement** in development and test environments
- **Automatic database setup** on first run
- **Port separation** - Dev on 3000, Tests on 3001

## 🚀 Quick Start

### Option 1: Use the start script
```bash
./start-dev.sh
```

### Option 2: Manual commands
```bash
# Start containers
docker-compose -f .devcontainer/docker-compose.yml up -d

# Start Rails server with SSL
docker-compose -f .devcontainer/docker-compose.yml exec rails ./bin/dev-server
```

## 🌐 Access Your Application

**Development**: Open your browser and navigate to: **https://care.lvh.me:3000**

> **Note**: You'll see a security warning for the self-signed certificate. Click "Advanced" → "Proceed to care.lvh.me"

## 🧪 Testing with HTTPS

### Quick Test Run
```bash
./run-tests.sh
```

### Manual Test Commands
```bash
# Stop all containers first
docker-compose -f .devcontainer/docker-compose.yml down

# Run tests with HTTPS at care.lvh.me:3001
docker-compose -f .devcontainer/docker-compose.yml run --rm -p 3001:3001 rails-test bash -c "
  bundle install &&
  bundle exec rails db:create db:migrate RAILS_ENV=test &&
  bundle exec puma -C config/puma.rb -b 'ssl://0.0.0.0:3001?key=config/ssl/care.lvh.me.key&cert=config/ssl/care.lvh.me.crt' -e test &
  sleep 5 &&
  bundle exec rspec &&
  kill %1
"
```

### Test Environment Features:
- **HTTPS at care.lvh.me:3001** - Separate from development
- **SSL certificates** automatically shared between dev and test
- **Force SSL enabled** in test environment
- **Capybara configured** for HTTPS testing
- **System tests** work with Selenium over HTTPS

## 📁 SSL Certificate Location

SSL certificates are stored in: `config/ssl/`
- `care.lvh.me.crt` - Certificate file
- `care.lvh.me.key` - Private key file

## 🔧 Environment Variables

Key SSL environment variables:
- `SSL_ENABLED=true` - Enables HTTPS
- `DOMAIN=care.lvh.me` - Development/test domain
- `PROTOCOL=https` - Forces HTTPS
- `PORT=3000` - Development port
- `PORT=3001` - Test port (rails-test service)

## 🛠️ Troubleshooting

### SSL Certificate Issues
If you encounter SSL problems, regenerate certificates:
```bash
docker-compose -f .devcontainer/docker-compose.yml exec rails rm -rf config/ssl/
docker-compose -f .devcontainer/docker-compose.yml exec rails ./bin/dev-server
```

### Port Already in Use
If ports are busy:
```bash
docker-compose -f .devcontainer/docker-compose.yml down
```

### Test Server Issues
If tests fail to connect:
```bash
# Check if certificates exist
docker-compose -f .devcontainer/docker-compose.yml run --rm rails-test ls -la config/ssl/

# Regenerate certificates
docker-compose -f .devcontainer/docker-compose.yml run --rm rails-test rm -rf config/ssl/
./run-tests.sh
```

## 🔄 Container Management

```bash
# Stop all containers
docker-compose -f .devcontainer/docker-compose.yml down

# Rebuild containers
docker-compose -f .devcontainer/docker-compose.yml build --no-cache

# View development logs
docker-compose -f .devcontainer/docker-compose.yml logs rails

# View test logs
docker-compose -f .devcontainer/docker-compose.yml logs rails-test
```

## 📝 Development vs Test

| Environment | URL | Port | SSL | Purpose |
|-------------|-----|------|-----|---------|
| Development | https://care.lvh.me:3000 | 3000 | ✅ | Interactive development |
| Test | https://care.lvh.me:3001 | 3001 | ✅ | Automated testing |

Both environments share the same SSL certificates but use different ports to avoid conflicts. 