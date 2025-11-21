# Art of Living Trading - E-commerce Project

A full-stack e-commerce application built with Ruby on Rails, MySQL, and Docker.

## Tech Stack

- **Backend**: Ruby 3.2.2, Rails 7.1
- **Database**: MySQL 8.0
- **Frontend**: Bootstrap 5, SCSS, Turbo/Stimulus
- **Authentication**: Devise
- **Admin Panel**: ActiveAdmin
- **Pagination**: Kaminari
- **Containerization**: Docker & Docker Compose

## Features

### Product Administration
- Admin dashboard with secure login
- CRUD operations for products
- Product image management
- Category management
- Seed data from JSON files

### Product Display
- Product listing with pagination
- Category navigation
- Product search by keyword and category
- Product filtering (on sale, new, recently updated)
- Product detail pages

### Shopping Cart & Orders
- Session-based shopping cart
- Cart quantity editing and item removal
- Checkout with tax calculation (GST/PST by province)
- Order history
- Order status management

### User Management
- User registration and login (Devise)
- Address management with province selection
- Role-based access (admin/user)

## Getting Started

### Prerequisites

- Docker Desktop installed
- Git installed

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ecommerce_project
   ```

2. **Build and start the containers**
   ```bash
   docker-compose build
   docker-compose up -d
   ```

3. **Create the Rails application (first time only)**
   ```bash
   docker-compose run --rm web rails new . --force --database=mysql --css=bootstrap --javascript=importmap
   ```

4. **Setup the database**
   ```bash
   docker-compose run --rm web rails db:create
   docker-compose run --rm web rails db:migrate
   docker-compose run --rm web rails db:seed
   ```

5. **Access the application**
   - Main site: http://localhost:3000
   - Admin panel: http://localhost:3000/admin

### Development Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f web

# Run Rails console
docker-compose run --rm web rails console

# Run migrations
docker-compose run --rm web rails db:migrate

# Run tests
docker-compose run --rm web rspec

# Generate a new model
docker-compose run --rm web rails g model ModelName field:type

# Generate a new controller
docker-compose run --rm web rails g controller ControllerName action1 action2
```

### Database Structure

The application uses the following main tables:
- `products_category` - Product categories
- `products` - Product information
- `products_detail` - Extended product details (JSON fields)
- `users` - User accounts
- `roles` - User roles (admin, user)
- `orders` - Customer orders
- `order_items` - Order line items
- `order_status` - Order status definitions

## Project Structure

```
ecommerce_project/
├── app/
│   ├── admin/          # ActiveAdmin resources
│   ├── controllers/    # Rails controllers
│   ├── models/         # Rails models
│   ├── views/          # ERB templates
│   └── assets/         # CSS, JS, images
├── config/
│   ├── routes.rb       # Application routes
│   └── database.yml    # Database configuration
├── db/
│   ├── migrate/        # Database migrations
│   └── seeds.rb        # Seed data
├── docker-compose.yml  # Docker services
├── Dockerfile          # Rails container
└── README.md
```

## Git Workflow

This project requires:
- 32+ commits spread over the project timeline
- 3+ feature branches merged to master
- Descriptive commit messages

## License

This project is for educational purposes.
