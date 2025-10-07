# Gemstash Management Commands

## 🚀 Service Control

### Start/Stop Services
```bash
# Start all services (including Gemstash)
docker-compose up -d

# Start only Gemstash
docker-compose up -d gemstash

# Stop Gemstash
docker-compose stop gemstash

# Restart Gemstash
docker-compose restart gemstash

# Stop all services
docker-compose down

# Stop and remove volumes (clears cache)
docker-compose down -v
```

## 📊 Monitoring & Status

### Check Service Health
```bash
# Quick status check
curl http://localhost:9292

# Detailed status with response
curl -v http://localhost:9292

# Check if Gemstash is responding
curl -f http://localhost:9292 && echo "✅ Gemstash is healthy" || echo "❌ Gemstash is down"
```

### View Logs
```bash
# Real-time logs
docker-compose logs -f gemstash

# Last 50 lines
docker-compose logs --tail=50 gemstash

# Logs since specific time
docker-compose logs --since="1h" gemstash

# Logs with timestamps
docker-compose logs -t gemstash
```

### Service Information
```bash
# Container status
docker-compose ps gemstash

# Container resource usage
docker stats devcontainer-gemstash-1

# Container details
docker inspect devcontainer-gemstash-1
```

## 🔧 Cache Management

### View Cache Contents
```bash
# List cached files
docker-compose exec gemstash find /gemstash -type f

# Cache directory size
docker-compose exec gemstash du -sh /gemstash

# Cache statistics
docker-compose exec gemstash ls -la /gemstash/
```

### Clear Cache
```bash
# Clear all cached data (nuclear option)
docker-compose down
docker volume rm devcontainer_gemstash-data
docker-compose up -d gemstash

# Restart to clear memory cache
docker-compose restart gemstash
```

## ⚙️ Bundler Configuration

### Configure Bundler to Use Gemstash
```bash
# Set Gemstash as mirror
bundle config mirror.https://rubygems.org http://localhost:9292

# Set fallback timeout (3 seconds)
bundle config mirror.https://rubygems.org.fallback_timeout 3

# View current mirror config
bundle config mirror.https://rubygems.org

# List all bundle config
bundle config list
```

### Remove Gemstash Configuration
```bash
# Remove mirror configuration
bundle config --delete mirror.https://rubygems.org

# Remove fallback timeout
bundle config --delete mirror.https://rubygems.org.fallback_timeout

# Reset to default (direct to rubygems.org)
bundle config --local --delete mirror.https://rubygems.org
```

## 🧪 Testing & Verification

### Test Gemstash Functionality
```bash
# Test basic connectivity
curl -I http://localhost:9292

# Test gem installation through cache
docker-compose run --rm rails bash -c "
  cd /tmp && 
  echo 'source \"https://rubygems.org\"' > Gemfile && 
  echo 'gem \"json\"' >> Gemfile && 
  bundle install --verbose
"

# Run comprehensive test
./test-gemstash.sh
```

### Performance Testing
```bash
# Time a bundle install (first run - cache miss)
time docker-compose run --rm rails bash -c "
  cd /tmp && 
  echo 'source \"https://rubygems.org\"' > Gemfile && 
  echo 'gem \"rack\"' >> Gemfile && 
  bundle install
"

# Time same install again (cache hit)
time docker-compose run --rm rails bash -c "
  cd /tmp && 
  echo 'source \"https://rubygems.org\"' > Gemfile && 
  echo 'gem \"rack\"' >> Gemfile && 
  bundle install
"
```

## 🔍 Debugging

### Debug Connection Issues
```bash
# Check network connectivity
docker-compose exec rails ping gemstash

# Test from Rails container
docker-compose exec rails curl -v http://gemstash:9292

# Check DNS resolution
docker-compose exec rails nslookup gemstash

# Check port availability
docker-compose exec rails telnet gemstash 9292
```

### Debug Gemstash Issues
```bash
# Interactive shell in Gemstash container
docker-compose exec gemstash bash

# Check Gemstash process
docker-compose exec gemstash ps aux | grep gemstash

# Check Ruby version and gems
docker-compose exec gemstash ruby --version
docker-compose exec gemstash gem list | grep gemstash
```

## 📱 Quick Commands

### Daily Usage
```bash
# Start development environment
docker-compose up -d

# Check everything is healthy
curl -f http://localhost:9292 && echo "✅ Ready to develop!"

# View recent activity
docker-compose logs --tail=10 gemstash

# Stop when done
docker-compose down
```

### Troubleshooting
```bash
# Full restart
docker-compose restart

# Nuclear restart (clears all cache)
docker-compose down -v && docker-compose up -d

# Check all service health
docker-compose ps
```

## 🌐 Web Interface

### Access Gemstash
- **URL**: http://localhost:9292
- **VS Code Port Forwarding**: Automatically configured
- **Direct Container Access**: http://gemstash:9292 (from other containers)

### Useful URLs
```bash
# Basic status
open http://localhost:9292

# Or via curl
curl http://localhost:9292
```
