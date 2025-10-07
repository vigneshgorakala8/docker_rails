#!/bin/bash

echo "🗃️ Setting up Gemstash for Docker Rails development..."

# Function to wait for service
wait_for_service() {
    local service=$1
    local url=$2
    local max_attempts=30
    local attempt=1
    
    echo "Waiting for $service to be ready..."
    while [ $attempt -le $max_attempts ]; do
        if curl -f "$url" >/dev/null 2>&1; then
            echo "✅ $service is ready!"
            return 0
        fi
        echo "Attempt $attempt/$max_attempts: $service not ready yet..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "❌ $service failed to start within expected time"
    return 1
}

# Start Gemstash service
echo "🚀 Starting Gemstash service..."
docker-compose up -d gemstash

# Wait for Gemstash to be ready
if wait_for_service "Gemstash" "http://localhost:9292"; then
    echo "🎉 Gemstash is now running!"
    echo ""
    echo "📊 Gemstash Status:"
    curl -s http://localhost:9292 && echo ""
    echo ""
    echo "🔧 Configuration:"
    echo "  - Gemstash URL: http://localhost:9292"
    echo "  - Cache location: Docker volume 'gemstash-data'"
    echo "  - Upstream: https://rubygems.org"
    echo "  - Cache expiration: 30 minutes"
    echo ""
    echo "📝 To configure Bundler manually:"
    echo "  bundle config mirror.https://rubygems.org http://localhost:9292"
    echo "  bundle config mirror.https://rubygems.org.fallback_timeout 3"
    echo ""
    echo "🧹 To clean mirror config:"
    echo "  bundle config --delete mirror.https://rubygems.org"
    echo ""
    echo "💡 Your Rails containers are already configured to use Gemstash!"
else
    echo "❌ Failed to start Gemstash"
    echo "Check logs with: docker-compose logs gemstash"
    exit 1
fi
