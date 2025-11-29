# Docker Setup and Usage

## Overview

This project is fully containerized using Docker and Docker Compose.

## Containers

1. **db** - MySQL 8.0 database
2. **web** - Rails 7.1 application

## Volumes

- `mysql_data` - Database persistence
- `bundle_cache` - Ruby gems cache
- `storage_data` - Active Storage uploaded files

## Development

### Start containers
```bash
docker-compose up -d
```

### Stop containers
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f web
```

### Rails console
```bash
docker-compose run --rm web rails console
```

### Run migrations
```bash
docker-compose run --rm web rails db:migrate
```

### Run tests
```bash
docker-compose run --rm web rails test
```

### Rebuild containers
```bash
docker-compose build
docker-compose up -d
```

## Production

### Build and start
```bash
docker-compose -f docker-compose.production.yml up -d --build
```

### View status
```bash
docker-compose -f docker-compose.production.yml ps
```

### Execute commands
```bash
docker-compose -f docker-compose.production.yml run --rm web rails db:migrate
```

## Troubleshooting

### Database connection issues
```bash
docker-compose restart db
```

### Permission issues
```bash
sudo chown -R $USER:$USER .
```

### Clean rebuild
```bash
docker-compose down -v
docker system prune -a
docker-compose up -d --build
```

### Check resource usage
```bash
docker stats
```

## File Structure
```
.
├── docker-compose.yml              # Development config
├── docker-compose.production.yml   # Production config
├── Dockerfile                       # Image definition
└── .env                            # Environment variables (gitignored)
```

## Requirements

- Docker 20.10+
- Docker Compose 2.0+

## Data Persistence

All data persists in Docker volumes even when containers are stopped/removed:

- Database data → `mysql_data` volume
- Uploaded images → `storage_data` volume
- Ruby gems → `bundle_cache` volume

To completely reset:
```bash
docker-compose down -v  # Deletes volumes
```
