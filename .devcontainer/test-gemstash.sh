#!/bin/bash

echo "🗃️ Testing Gemstash integration with Rails development environment..."

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        return 1
    fi
}

echo "🚀 Starting all services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 30

echo ""
echo "📊 Testing service health..."

# Test Gemstash
echo -n "Testing Gemstash... "
curl -f http://localhost:9292 >/dev/null 2>&1
print_status $? "Gemstash is responding"

# Test PostgreSQL
echo -n "Testing PostgreSQL... "
docker-compose exec postgres pg_isready -U postgres >/dev/null 2>&1
print_status $? "PostgreSQL is ready"

# Test Redis
echo -n "Testing Redis... "
docker-compose exec redis redis-cli ping >/dev/null 2>&1
print_status $? "Redis is responding"

# Test Selenium
echo -n "Testing Selenium... "
curl -f http://localhost:4444/wd/hub/status >/dev/null 2>&1
print_status $? "Selenium is ready"

echo ""
echo "🔧 Testing Bundler configuration..."

# Test Bundler mirror configuration
echo -n "Testing Bundler mirror config... "
MIRROR_CONFIG=$(docker-compose run --rm rails bash -c "bundle config mirror.https://rubygems.org" 2>/dev/null | grep "http://gemstash:9292" || echo "")
if [ -n "$MIRROR_CONFIG" ]; then
    print_status 0 "Bundler mirror is configured for Gemstash"
else
    print_status 1 "Bundler mirror configuration failed"
fi

echo ""
echo "📦 Testing gem installation through Gemstash..."

# Test installing a small gem through Gemstash
echo -n "Installing a test gem through Gemstash... "
TEST_OUTPUT=$(docker-compose run --rm rails bash -c "
    cd /tmp && 
    echo 'gem \"json\"' > Gemfile &&
    echo 'source \"https://rubygems.org\"' | cat - Gemfile > temp && mv temp Gemfile &&
    bundle install --quiet 2>&1
" 2>/dev/null)

if echo "$TEST_OUTPUT" | grep -q "Complete" || echo "$TEST_OUTPUT" | grep -q "installed"; then
    print_status 0 "Gem installation through Gemstash successful"
else
    print_status 1 "Gem installation through Gemstash failed"
    echo "Output: $TEST_OUTPUT"
fi

echo ""
echo "📊 Gemstash usage statistics:"
echo "Access Gemstash web interface at: http://localhost:9292"
echo ""
echo "🎉 Gemstash integration test completed!"
echo ""
echo "📝 Usage summary:"
echo "  - Gemstash is running on port 9292"
echo "  - Rails containers automatically use Gemstash as a mirror"
echo "  - Gems are cached for faster subsequent installations"
echo "  - 3-second fallback timeout to rubygems.org if Gemstash is unavailable"
echo ""
echo "🛠️ Management commands:"
echo "  docker-compose logs gemstash     # View Gemstash logs"
echo "  curl http://localhost:9292      # Check Gemstash status"
echo "  docker-compose restart gemstash # Restart Gemstash"
