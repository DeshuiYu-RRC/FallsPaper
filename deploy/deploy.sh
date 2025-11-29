#!/bin/bash

echo "🚀 Deploying FallsPaper..."

# Pull latest code
echo "📥 Pulling latest code..."
git pull

# Build and start containers
echo "🐳 Building and starting containers..."
docker-compose -f docker-compose.production.yml up -d --build

# Wait for containers to be ready
echo "⏳ Waiting for containers to start..."
sleep 10

# Run migrations
echo "🗄️  Running database migrations..."
docker-compose -f docker-compose.production.yml run --rm web rails db:migrate

# Restart to apply changes
echo "🔄 Restarting application..."
docker-compose -f docker-compose.production.yml restart web

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Your site should be accessible at:"
echo "   http://$(curl -s ifconfig.me)"
echo ""
