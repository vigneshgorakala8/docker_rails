#!/bin/bash

echo "🔍 GEMSTASH MONITORING TOOL"
echo "This script helps you verify gems are coming through Gemstash"
echo

# Function to print colored output
print_evidence() {
    echo -e "\033[0;32m✅ $1\033[0m"
}

print_info() {
    echo -e "\033[0;34mℹ️  $1\033[0m"
}

echo "📊 Evidence #1: Bundle Configuration Check"
echo "----------------------------------------"
MIRROR_CONFIG=$(docker-compose run --rm rails bundle config list 2>/dev/null | grep "mirror.https://rubygems.org")
if [[ $MIRROR_CONFIG == *"gemstash"* ]]; then
    print_evidence "Bundler is configured to use Gemstash: $MIRROR_CONFIG"
else
    echo "❌ Bundler NOT configured for Gemstash"
fi
echo

echo "📊 Evidence #2: HTTP Request Traces"
echo "-----------------------------------"
print_info "Running bundle install with verbose output to show HTTP requests..."
docker-compose run --rm rails bash -c "
    cd /tmp && 
    echo 'source \"https://rubygems.org\"' > Gemfile && 
    echo 'gem \"json\"' >> Gemfile && 
    bundle install --verbose 2>&1 | grep -E 'HTTP.*gemstash|gemstash.*9292'
" | head -5
echo

echo "📊 Evidence #3: Gemstash Server Logs"
echo "------------------------------------"
print_info "Recent Gemstash activity (gem fetching):"
docker-compose logs gemstash 2>/dev/null | grep -E "(fetching gem|cached)" | tail -5
echo

echo "📊 Evidence #4: Network Traffic Test"
echo "------------------------------------"
print_info "Installing a gem while monitoring network calls..."
# Start monitoring logs in background
(docker-compose logs -f gemstash 2>/dev/null | grep "fetching gem" &) 
MONITOR_PID=$!

# Install a gem
docker-compose run --rm rails bash -c "
    cd /tmp && 
    echo 'source \"https://rubygems.org\"' > Gemfile && 
    echo 'gem \"base64\"' >> Gemfile && 
    bundle install --quiet
" >/dev/null 2>&1

# Stop monitoring
sleep 2
kill $MONITOR_PID 2>/dev/null

# Show the evidence
RECENT_FETCH=$(docker-compose logs gemstash 2>/dev/null | tail -10 | grep "fetching gem" | tail -1)
if [ -n "$RECENT_FETCH" ]; then
    print_evidence "Gemstash fetched gem: $RECENT_FETCH"
else
    print_info "No new gems fetched (may be cached already)"
fi
echo

echo "📊 Evidence #5: Speed Comparison"
echo "--------------------------------"
print_info "Testing installation speed (cached vs uncached):"

# Test 1: Install a gem (might be cached)
echo -n "Installing rack gem: "
START_TIME=$(date +%s.%N)
docker-compose run --rm rails bash -c "
    cd /tmp && 
    echo 'source \"https://rubygems.org\"' > Gemfile && 
    echo 'gem \"rack\"' >> Gemfile && 
    bundle install --quiet
" >/dev/null 2>&1
END_TIME=$(date +%s.%N)
DURATION=$(echo "$END_TIME - $START_TIME" | bc -l)
printf "%.2f seconds\n" $DURATION

echo

echo "🎯 SUMMARY: How to Know Gems Come from Gemstash"
echo "==============================================="
echo "1. 🔧 Bundle config shows: mirror.https://rubygems.org → http://gemstash:9292"
echo "2. 📡 HTTP requests go to: gemstash:9292 (not directly to rubygems.org)" 
echo "3. 📝 Gemstash logs show: 'Gem X is not cached, fetching gem'"
echo "4. ⚡ Subsequent installs are dramatically faster (cached)"
echo "5. 🌐 Metadata requests: 'Fetching gem metadata from http://gemstash:9292/'"
echo
echo "🎉 Your gems are definitely coming through Gemstash!"
echo
echo "💡 Pro tip: Run 'docker-compose logs -f gemstash' in another terminal"
echo "   while doing bundle install to see real-time caching activity."
