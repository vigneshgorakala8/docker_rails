#!/bin/bash

echo "🔧 Testing Docker Compose fix..."

# Stop any running containers
echo "Stopping existing containers..."
docker-compose down

# Clean up
echo "Cleaning up volumes..."
docker-compose down -v

# Start services in the background
echo "Starting services..."
docker-compose up -d postgres redis selenium

# Wait for services to be healthy
echo "Waiting for services to be ready..."
sleep 10

# Check Selenium status
echo "Checking Selenium status..."
docker-compose exec selenium curl -f http://localhost:4444/wd/hub/status

# Run the test
echo "Running tests..."
docker-compose run --rm rails-test bundle exec rspec spec/system/home_system_spec.rb:8

echo "✅ Test completed!"
