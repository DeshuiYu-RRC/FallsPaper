FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    yarn \
    default-mysql-client \
    build-essential \
    libmariadb-dev \
    imagemagick \
    libvips42 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]