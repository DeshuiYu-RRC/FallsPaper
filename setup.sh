#!/bin/bash

# E-commerce Project Setup Script
# This script helps you set up the Rails e-commerce project step by step

set -e

echo "================================================"
echo "  Art of Living Trading - E-commerce Setup"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop first."
        exit 1
    fi
    print_status "Docker is running"
}

# Step 1: Build Docker images
build_images() {
    echo ""
    echo "Step 1: Building Docker images..."
    docker-compose build
    print_status "Docker images built successfully"
}

# Step 2: Start database service
start_database() {
    echo ""
    echo "Step 2: Starting database service..."
    docker-compose up -d db
    
    # Wait for database to be healthy
    echo "Waiting for database to be ready..."
    sleep 10
    
    until docker-compose exec -T db mysqladmin ping -h localhost -u admin -pfallspaper --silent 2>/dev/null; do
        echo "Still waiting for database..."
        sleep 5
    done
    
    print_status "Database is ready"
}

# Step 3: Create Rails application
create_rails_app() {
    echo ""
    echo "Step 3: Creating Rails application..."
    
    # Check if Rails app already exists
    if [ -f "config/application.rb" ]; then
        print_warning "Rails application already exists, skipping creation"
        return
    fi
    
    docker-compose run --rm web bash -c "
        gem install rails -v '~> 7.1.0' &&
        rails new . --force --database=mysql --css=bootstrap --javascript=importmap --skip-test
    "
    
    print_status "Rails application created"
}

# Step 4: Configure database
configure_database() {
    echo ""
    echo "Step 4: Configuring database connection..."
    
    # Create database.yml
    cat > config/database.yml << 'EOF'
default: &default
  adapter: mysql2
  encoding: utf8mb4
  collation: utf8mb4_unicode_ci
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("DATABASE_HOST") { "localhost" } %>
  username: <%= ENV.fetch("DATABASE_USERNAME") { "admin" } %>
  password: <%= ENV.fetch("DATABASE_PASSWORD") { "fallspaper" } %>

development:
  <<: *default
  database: <%= ENV.fetch("DATABASE_NAME") { "fallspaper" } %>

test:
  <<: *default
  database: fallspaper_test

production:
  <<: *default
  database: fallspaper_production
EOF
    
    print_status "Database configuration updated"
}

# Step 5: Install gems
install_gems() {
    echo ""
    echo "Step 5: Installing gems..."
    docker-compose run --rm web bundle install
    print_status "Gems installed"
}

# Step 6: Setup database
setup_database() {
    echo ""
    echo "Step 6: Setting up database..."
    docker-compose run --rm web rails db:create
    print_status "Database created"
}

# Step 7: Start all services
start_services() {
    echo ""
    echo "Step 7: Starting all services..."
    docker-compose up -d
    print_status "All services started"
}

# Main execution
main() {
    check_docker
    
    echo ""
    echo "This script will set up your Rails e-commerce project."
    echo "Press Enter to continue or Ctrl+C to cancel..."
    read
    
    build_images
    start_database
    create_rails_app
    configure_database
    install_gems
    setup_database
    start_services
    
    echo ""
    echo "================================================"
    print_status "Setup complete!"
    echo "================================================"
    echo ""
    echo "Your application is now running at:"
    echo "  - Main site: http://localhost:3000"
    echo ""
    echo "Next steps:"
    echo "  1. Run: docker-compose run --rm web rails db:migrate"
    echo "  2. Run: docker-compose run --rm web rails db:seed"
    echo "  3. Visit http://localhost:3000"
    echo ""
    echo "Useful commands:"
    echo "  - View logs: docker-compose logs -f web"
    echo "  - Stop services: docker-compose down"
    echo "  - Rails console: docker-compose run --rm web rails console"
    echo ""
}

# Run main function
main
