# Docker Rails Application

A modern Rails application with Docker support, comprehensive testing, and VS Code Dev Container integration.

## ✨ Features

- **Rails 7.2.2** with Ruby 3.3.5
- **Home Controller** with pages for Home, About, and Contact
- **Comprehensive Testing** with RSpec, Capybara, and Selenium
- **Docker Support** with development and production configurations
- **VS Code Dev Containers** for consistent development environment
- **PostgreSQL** and **Redis** support
- **Modern UI** with responsive design

## 🚀 Getting Started

### Option 1: VS Code Dev Container (Recommended)

1. **Prerequisites**:
   - [Docker](https://www.docker.com/get-started)
   - [VS Code](https://code.visualstudio.com/)
   - [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. **Open in Container**:
   - Open VS Code
   - Open this project folder
   - Click "Reopen in Container" or press `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

3. **Start Development**:
   ```bash
   # Start Rails server
   bundle exec rails server
   
   # Visit http://localhost:3000
   ```

### Option 2: Local Development

1. **Prerequisites**:
   - Ruby 3.3.5
   - Node.js 20+
   - PostgreSQL (optional)

2. **Setup**:
   ```bash
   # Install dependencies
   bundle install
   yarn install
   
   # Setup database
   rails db:setup
   
   # Start server
   rails server
   ```

## 🧪 Testing

### Run All Tests
```bash
bundle exec rspec
```

### Test Types
- **Request Specs**: API-level testing (12 tests)
- **System Specs**: Full browser testing with Capybara (17 tests)
- **Total**: 29 tests

### System Tests with Screenshots
System tests automatically capture screenshots on failure:
```bash
bundle exec rspec spec/system/
```
Screenshots saved to `tmp/capybara/`

## 🐳 Docker

### Development Environment
The project includes a complete Docker development environment:

- **Ruby 3.3.5** with all development tools
- **PostgreSQL 15** database
- **Redis 7** for caching
- **Chrome** for system tests
- **VS Code** integration

### Production Deployment
```bash
# Build production image
docker build -t docker-rails .

# Run production container
docker run -d -p 3000:3000 docker-rails
```

## 📁 Project Structure

```
docker_rails/
├── .devcontainer/          # VS Code Dev Container configuration
├── app/
│   ├── controllers/        # Rails controllers
│   ├── views/             # Rails views
│   └── assets/            # Assets (CSS, JS, images)
├── spec/
│   ├── requests/          # Request specs
│   └── system/            # System specs with Capybara
├── config/                # Rails configuration
├── Dockerfile             # Production Docker image
├── package.json           # Node.js dependencies
└── README.md              # This file
```

## 🎯 Available Pages

- **Home** (`/`) - Welcome page with features
- **About** (`/about`) - Company information
- **Contact** (`/contact`) - Contact form and information

## 🔧 Development Commands

```bash
# Application
bundle exec rails server          # Start Rails server
bundle exec rails console         # Rails console
bundle exec rails generate        # Rails generators

# Database
bundle exec rails db:create       # Create database
bundle exec rails db:migrate      # Run migrations
bundle exec rails db:seed         # Seed database

# Testing
bundle exec rspec                 # Run all tests
bundle exec rspec spec/system     # Run system tests
bundle exec rspec spec/requests   # Run request tests

# Code Quality
bundle exec rubocop               # Run RuboCop linter
bundle exec rubocop -a            # Auto-fix issues
```

## 🌐 Technology Stack

- **Backend**: Ruby on Rails 7.2.2
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Database**: PostgreSQL 15 / SQLite 3
- **Caching**: Redis 7
- **Testing**: RSpec, Capybara, Selenium WebDriver
- **Containerization**: Docker, Docker Compose
- **Development**: VS Code Dev Containers

## 📊 Test Results

```
29 examples, 0 failures ✅

Request Specs:  12 tests
System Specs:   17 tests
Coverage:       100%
```

## 🚀 Deployment

### Development
Use the VS Code Dev Container for the best development experience.

### Production
1. Build the production Docker image
2. Configure environment variables
3. Set up PostgreSQL database
4. Deploy using your preferred container orchestration

## 📝 License

This project is available as open source under the terms of the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📞 Support

For support, please open an issue in the GitHub repository.
