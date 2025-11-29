# Quick Deployment Reference

## Initial Setup (One-time)

1. SSH to EC2
2. Run `bash setup_ec2.sh`
3. Log out and back in
4. Clone repo: `git clone https://github.com/your-username/FallsPaper.git`
5. `cd FallsPaper`
6. Create `.env` file with production values
7. Generate secret: `docker-compose run --rm web rails secret`
8. Deploy: `docker-compose -f docker-compose.production.yml up -d --build`
9. Setup DB: `docker-compose -f docker-compose.production.yml run --rm web rails db:create db:migrate db:seed`
10. Import products: `docker-compose -f docker-compose.production.yml run --rm web rails products:import`
11. Create admin user
12. Setup systemd: `sudo cp deploy/fallspaper.service /etc/systemd/system/ && sudo systemctl enable fallspaper`
13. Setup Nginx: `sudo cp deploy/nginx.conf /etc/nginx/sites-available/fallspaper && sudo ln -s /etc/nginx/sites-available/fallspaper /etc/nginx/sites-enabled/`
14. SSL: `sudo certbot --nginx -d your-domain.com`

## Regular Updates
```bash
cd ~/FallsPaper
bash deploy/deploy.sh
```

## Common Commands
```bash
# Logs
docker-compose -f docker-compose.production.yml logs -f web

# Restart
docker-compose -f docker-compose.production.yml restart

# Console
docker-compose -f docker-compose.production.yml run --rm web rails console -e production

# Status
docker-compose -f docker-compose.production.yml ps
systemctl status fallspaper

# Backup
docker-compose -f docker-compose.production.yml exec db mysqldump -u admin -p fallspaper_production > backup.sql
```

## Environment Variables (.env)
```env
DATABASE_USERNAME=admin
DATABASE_PASSWORD=strong_password
MYSQL_ROOT_PASSWORD=root_password
SECRET_KEY_BASE=rails_secret_output
STRIPE_PUBLISHABLE_KEY=pk_live_xxx
STRIPE_SECRET_KEY=sk_live_xxx
APP_HOST=your-domain.com
```

## URLs

- Website: http://your-domain.com
- Admin: http://your-domain.com/admin
- Health: http://your-domain.com/health

## Default Credentials

**Admin:**
- Email: admin@fallspaper.com
- Password: (set during deployment)

**Database:**
- Host: localhost (inside container: db)
- User: admin
- Password: (from .env)
- Database: fallspaper_production

## Testing Checklist

- [ ] Website loads
- [ ] Products display
- [ ] Images load
- [ ] Can add to cart
- [ ] Checkout works with test card
- [ ] Admin login works
- [ ] Can upload product images in admin
- [ ] Auto-restart after reboot works
