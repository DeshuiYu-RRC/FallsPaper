# FallsPaper - E-commerce Platform

A full-stack e-commerce web application built with Ruby on Rails for selling office paper and printing supplies.

## Features

### Customer Features
- Product Browsing: View products by category with filtering and pagination
- Shopping Cart: Add, update, and remove items from cart
- User Authentication: Sign up, login, logout with Devise
- Checkout Process: Complete purchase with Stripe payment integration
- Order Management: View order history and track order status
- Tax Calculation: Automatic GST/PST calculation based on province
- Responsive Design: Mobile-friendly Bootstrap 5 UI

### Admin Features
- Admin Dashboard: Powered by ActiveAdmin
- Product Management: CRUD operations with image uploads and variants
- Order Management: View and update order status
- User Management: Manage customer accounts
- Category Management: Organize products into categories
- Analytics: View sales data and order statistics

### Technical Features
- Payment Processing: Stripe integration for secure payments
- Image Processing: Active Storage with automatic image scaling (thumb, small, medium, large)
- Email Notifications: Order confirmations and status updates
- Database: MySQL 8.0 with optimized indexes
- Containerization: Docker and Docker Compose for easy deployment
- Testing: Comprehensive Cypress E2E tests (17 tests covering auth and checkout)
- Code Quality: Rubocop configured for Rails best practices

---

## Tech Stack

- Backend: Ruby 3.2.2, Rails 7.1.6
- Database: MySQL 8.0
- Frontend: Bootstrap 5, JavaScript, Turbo
- Payment: Stripe API
- File Storage: Active Storage (local filesystem)
- Admin Panel: ActiveAdmin
- Authentication: Devise
- Image Processing: ImageMagick, libvips
- Testing: Cypress (E2E)
- Deployment: Docker, Docker Compose, Nginx

---

## Prerequisites

### For Local Development
- Docker Desktop
- Git
- Node.js 14+ (for Cypress tests)

### For Production Deployment
- AWS EC2 instance (Ubuntu 22.04+)
- Domain name (optional)
- Stripe account (test or live keys)

---

## Quick Start (Local Development)

### 1. Clone the Repository
```bash
git clone https://github.com/DeshuiYu-RRC/FallsPaper.git
cd FallsPaper
```

### 2. Create Environment File
```bash
cp .env.example .env
```

Edit `.env` with your settings:
```env
# Database
DATABASE_USERNAME=admin
DATABASE_PASSWORD=your_password_here
MYSQL_ROOT_PASSWORD=your_root_password_here
DATABASE_NAME=fallspaper

# Stripe (Test Keys)
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
STRIPE_SECRET_KEY=your_stripe_secret_key
```

### 3. Build and Start Containers
```bash
docker-compose up -d --build
```

Wait 2-3 minutes for the first build.

### 4. Setup Database
```bash
# Create database
docker-compose run --rm web rails db:create

# Run migrations
docker-compose run --rm web rails db:migrate

# Seed database (categories, roles, provinces, order statuses)
docker-compose run --rm web rails db:seed

# Import all 120 products
docker-compose run --rm web rails products:import
```

### 5. Access the Application

**Website**: http://localhost:3000

**Admin Panel**: http://localhost:3000/admin

Default admin credentials are created during db:seed

---

## Testing

### Run Cypress E2E Tests
```bash
# Install dependencies
npm install

# Make sure the app is running
docker-compose up -d

# Run all tests (headless)
npx cypress run

# Open Cypress UI (interactive)
npx cypress open
```

**Test Coverage** (17 tests):

Authentication Tests (9 tests):
- User registration (happy path)
- Registration validation errors (existing email, password mismatch, short password)
- User login (happy path)
- Login errors (wrong password, non-existent email, empty form)
- User logout

Cart & Checkout Tests (8 tests):
- Complete purchase flow (add to cart, checkout, payment)
- Empty cart prevention
- Checkout form validation
- Province selection requirement
- Cart quantity validation
- Out of stock products
- Remove items from cart
- Clear entire cart

### Run Rubocop (Code Quality)
```bash
# Check code quality
docker-compose run --rm web rubocop

# Auto-fix issues
docker-compose run --rm web rubocop -A
```

---

## Using the Application

### As a Customer

#### 1. Browse Products
- Visit http://localhost:3000
- Click Products to view all products
- Filter by category using the sidebar
- Use pagination to browse through products

#### 2. Add to Cart
- Click Add to Cart on any product card
- Or click product name, view details, then Add to Cart
- Cart badge shows number of items

#### 3. Manage Cart
- Click Cart icon in navigation
- Update quantities using number inputs and Update button
- Remove individual items with delete icon
- Clear entire cart with Clear Cart button

#### 4. Checkout
- Click Proceed to Checkout in cart
- Login or create account
- Fill in delivery information
- Select province (for tax calculation)
- Enter Stripe test card: 4242 4242 4242 4242
  - Expiry: Any future date (e.g., 12/28)
  - CVC: Any 3 digits (e.g., 123)
- Click Place Order & Pay

#### 5. View Orders
- Click username dropdown, then My Orders
- View order details by clicking order number
- See order status: Pending, Paid, Shipped

### As an Admin

#### 1. Access Admin Panel
- Visit http://localhost:3000/admin
- Login with admin credentials

#### 2. Manage Products
- Dashboard, then Products
- New Product: Add title, prices, category, upload image
- Edit: Click product, then Edit Product
- View: See all image variants (thumb, small, medium, large)

#### 3. Manage Orders
- Dashboard, then Orders
- View all orders with status badges
- Click order, then Edit Order to change status
- Mark as Shipped button for paid orders
- View Stripe payment links

#### 4. Manage Users
- Dashboard, then Users
- View customer accounts
- Edit user roles and verification status

---

## Common Commands

### Docker Commands
```bash
# Start containers
docker-compose up -d

# Stop containers
docker-compose down

# View logs
docker-compose logs -f web

# Restart application
docker-compose restart web

# Access Rails console
docker-compose run --rm web rails console

# Run migrations
docker-compose run --rm web rails db:migrate

# Rebuild containers
docker-compose up -d --build
```

### Database Commands
```bash
# Create database
docker-compose run --rm web rails db:create

# Drop database
docker-compose run --rm web rails db:drop

# Reset database (drop, create, migrate, seed)
docker-compose run --rm web rails db:reset

# Import products
docker-compose run --rm web rails products:import
```

### Production Commands
```bash
# Build for production
docker-compose -f docker-compose.production.yml build

# Start production
docker-compose -f docker-compose.production.yml up -d

# View production logs
docker-compose -f docker-compose.production.yml logs -f
```

---

## Production Deployment (AWS EC2)

### Quick Deployment Steps

1. Launch EC2 Instance (Ubuntu 22.04, t2.small or larger)

2. Configure Security Group:
   - Port 22 (SSH)
   - Port 80 (HTTP)
   - Port 443 (HTTPS - optional)

3. SSH into EC2:
```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_IP
```

4. Install Docker:
```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add user to docker group
sudo usermod -aG docker $USER
```

5. Clone and Setup:
```bash
git clone https://github.com/DeshuiYu-RRC/FallsPaper.git
cd FallsPaper

# Create production .env
nano .env
# Add production values (see .env.example)

# Build and start
docker-compose -f docker-compose.production.yml up -d --build

# Setup database
docker-compose -f docker-compose.production.yml run --rm web rails db:create
docker-compose -f docker-compose.production.yml run --rm web rails db:migrate
docker-compose -f docker-compose.production.yml run --rm web rails db:seed
docker-compose -f docker-compose.production.yml run --rm web rails products:import
```

6. Install Nginx:
```bash
sudo apt-get install -y nginx

# Create config
sudo nano /etc/nginx/sites-available/fallspaper
```

Paste:
```nginx
server {
    listen 80;
    server_name YOUR_EC2_IP_OR_DOMAIN;

    client_max_body_size 20M;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable:
```bash
sudo ln -s /etc/nginx/sites-available/fallspaper /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

7. Visit Your Site: http://YOUR_EC2_IP

For detailed deployment instructions, see `deploy/DEPLOYMENT.md`

---

## Project Structure
```
FallsPaper/
├── app/
│   ├── admin/              # ActiveAdmin resources
│   ├── controllers/        # Application controllers
│   ├── models/             # Database models
│   ├── views/              # View templates
│   └── helpers/            # View helpers
├── config/
│   ├── database.yml        # Database configuration
│   ├── routes.rb           # Application routes
│   └── initializers/       # App initialization
├── db/
│   ├── migrate/            # Database migrations
│   └── seeds.rb            # Seed data
├── public/                 # Static files
├── storage/                # Active Storage uploads
├── cypress/                # E2E tests
│   ├── e2e/               # Test specs
│   └── support/           # Test helpers
├── deploy/                 # Deployment scripts
├── docker-compose.yml      # Development Docker config
├── docker-compose.production.yml  # Production Docker config
├── Dockerfile             # Docker image definition
├── Gemfile                # Ruby dependencies
└── package.json           # Node.js dependencies
```

---

## Database Schema

### Main Tables
- users: Customer accounts
- products: Product catalog
- products_category: Product categories
- products_detail: Detailed product information
- orders: Customer orders
- order_items: Order line items
- order_status: Order statuses (pending, paid, shipped, cancelled)
- provinces: Canadian provinces (for tax calculation)

### Image Storage
- active_storage_blobs: File metadata
- active_storage_attachments: File associations
- active_storage_variant_records: Image variant cache

---

## Payment Integration

### Stripe Test Cards

Success:
- Card: 4242 4242 4242 4242
- Expiry: Any future date
- CVC: Any 3 digits

Declined:
- Card: 4000 0000 0000 0002

Requires Authentication:
- Card: 4000 0025 0000 3155

### Tax Calculation

GST (5%) applies to all provinces.

Additional PST:
- Manitoba (7%)
- Saskatchewan (6%)
- BC (7%)
- Quebec (9.975%)

---

## Troubleshooting

### Port 3000 Already in Use
```bash
# Find and kill process
lsof -ti:3000 | xargs kill -9
```

### Database Connection Error
```bash
# Restart database container
docker-compose restart db

# Check database logs
docker-compose logs db
```

### Assets Not Loading
```bash
# Clear cache and rebuild
docker-compose down
docker-compose up -d --build
```

### Stripe Payments Failing
- Check .env has correct Stripe keys
- Verify using test card: 4242 4242 4242 4242
- Check browser console for errors

### Cypress Tests Failing
```bash
# Make sure app is running
docker-compose up -d

# Clear Cypress cache
npx cypress cache clear
rm -rf node_modules
npm install
```

---

## Contributors

Deshui Yu - Full Stack Developer

---

## Academic Project

This project was developed as part of the Full Stack Web Development program at Red River College Polytechnic.

**Features Implemented**:
- User authentication and authorization
- Shopping cart functionality
- Payment processing with Stripe
- Admin dashboard with ActiveAdmin
- Responsive design with Bootstrap
- Image upload with automatic scaling (4 variants)
- E2E testing with Cypress (17 tests)
- Code quality with Rubocop
- Docker containerization
- AWS EC2 deployment

