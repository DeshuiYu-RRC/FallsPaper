# Falls Paper - E-commerce Application

A full-stack e-commerce application built with Ruby on Rails, MySQL, and Docker.

## Features

### Customer Features
- Browse products by category
- Search products by keyword
- Filter products (on sale, new arrivals, recently updated)
- View product details with specifications
- Add products to shopping cart
- Update cart quantities and remove items
- Checkout with tax calculation by province
- User registration and login
- View order history
- Manage user profile and address

### Admin Features
- Dashboard with statistics
- Manage products (CRUD)
- Manage categories
- Manage orders and order status
- Manage users
- Manage provinces and tax rates
- View login history

## Tech Stack

- **Backend**: Ruby 3.2.2, Rails 7.1
- **Database**: MySQL 8.0
- **Frontend**: Bootstrap 5, ERB templates
- **Authentication**: Devise
- **Admin Panel**: ActiveAdmin
- **Pagination**: Kaminari
- **Containerization**: Docker & Docker Compose

## Getting Started

### Prerequisites
- Docker Desktop
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd fallspaper
   ```

2. Build and start containers:
   ```bash
   docker-compose build
   docker-compose up -d
   ```

3. Setup database:
   ```bash
   docker-compose run --rm web rails db:create db:migrate db:seed
   ```

4. Visit the application:
   - Main site: http://localhost:3000
   - Admin panel: http://localhost:3000/admin

### Default Credentials

**Admin User:**
- Email: admin@fallspaper.com
- Password: password123

**Test Customer:**
- Email: customer@test.com
- Password: password123

## Development Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f web

# Rails console
docker-compose run --rm web rails console

# Run migrations
docker-compose run --rm web rails db:migrate

# Run seeds
docker-compose run --rm web rails db:seed

# Update products from JSON
docker-compose run --rm web rails products:update
```

## Project Structure

```
app/
  admin/          # ActiveAdmin resources
  controllers/    # Rails controllers
  models/         # Rails models
  views/          # ERB templates
config/
  routes.rb       # Application routes
  initializers/   # Devise, ActiveAdmin, Kaminari configs
db/
  data/           # JSON seed data files
  migrate/        # Database migrations
  seeds.rb        # Database seeder
```

## Canadian Tax Rates

The application supports GST, PST, and HST calculations for all Canadian provinces and territories.

## License

This project is for educational purposes.
