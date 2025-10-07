FROM ruby:3.3.8

# Install CA certificates and update them
RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    wget \
    libpq-dev \
    zlib1g-dev \
    libreadline-dev \
    libyaml-dev \
    libffi-dev \
    pkg-config \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS) and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    corepack enable && \
    corepack prepare yarn@stable --activate


RUN gem install bundler

# Set bundle path
ENV BUNDLE_PATH=/workspaces/hal/vendor/bundle
