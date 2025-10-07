# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Install base packages and development tools
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    # Base packages
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    # Development packages
    build-essential \
    git \
    pkg-config \
    # PostgreSQL client
    libpq-dev \
    postgresql-client \
    # YAML support for psych gem
    libyaml-dev \
    # Node.js (for asset pipeline)
    nodejs \
    npm \
    # SSL support
    openssl \
    ca-certificates \
    # Additional development tools
    vim \
    nano \
    less \
    htop \
    # Chrome for system tests
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Chrome for system tests (commented out for now)
# RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
#     && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
#     && apt-get update -qq \
#     && apt-get install -y google-chrome-stable \
#     && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Yarn
RUN npm install -g yarn

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=""

# Create rails user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Install bundler
RUN gem install bundler

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy package.json and install Node packages
COPY package.json yarn.lock* ./
RUN yarn install

# Create necessary directories and set permissions
RUN mkdir -p /rails/tmp/pids /rails/tmp/cache /rails/log /rails/storage /rails/config/ssl && \
    chown -R rails:rails /rails && \
    chmod -R 755 /rails && \
    chown -R rails:rails /usr/local/bundle

# Switch to rails user
USER rails

# Copy application code
COPY --chown=rails:rails . .

# Expose port for HTTPS
EXPOSE 3000

# Default command
CMD ["bash"] 