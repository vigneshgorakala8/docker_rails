#!/bin/bash

# DevContainer Setup Script
set -e

echo "🚀 Setting up Docker Rails Development Environment..."

# Install dependencies
echo "📦 Installing Ruby gems..."
bundle install

# Install Node dependencies
echo "📦 Installing Node packages..."
yarn install

# Setup database
echo "🗄️  Setting up database..."
if [ "$DATABASE_URL" ]; then
  echo "Using PostgreSQL database"
  bundle exec rails db:create
  bundle exec rails db:migrate
else
  echo "Using SQLite database"
  bundle exec rails db:setup
fi

# Run tests to ensure everything is working
echo "🧪 Running tests..."
bundle exec rspec

echo "✅ Setup complete!"
echo ""
echo "🎉 Your Rails development environment is ready!"
echo ""
echo "To start the Rails server:"
echo "  bundle exec rails server"
echo ""
echo "To run tests:"
echo "  bundle exec rspec"
echo ""
echo "To run system tests:"
echo "  bundle exec rspec spec/system"
echo ""
echo "Happy coding! 🚀" 