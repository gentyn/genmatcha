#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting deployment..."

# Pull latest changes
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the site
echo "🏗️ Building site..."
npm run build

# Sync to server
echo "📤 Syncing to server..."
rsync -avz --delete -e "ssh -p 12202 -i /home/genesis/.ssh/genmatcha_deploy" \
    dist/ \
    newmoonadmin@newmooncloud.com:/tmp/genmatcha/

# Move files to web directory and set permissions
echo "🔄 Setting up files on server..."
ssh -p 12202 -i /home/genesis/.ssh/genmatcha_deploy newmoonadmin@newmooncloud.com "sudo rm -rf /var/www/newmooncloud/* && sudo mv /tmp/genmatcha/* /var/www/newmooncloud/ && sudo chown -R www-data:www-data /var/www/newmooncloud && sudo chmod -R 755 /var/www/newmooncloud"

# Restart Apache
echo "🔄 Restarting Apache..."
ssh -p 12202 -i /home/genesis/.ssh/genmatcha_deploy newmoonadmin@newmooncloud.com "sudo systemctl restart apache2"

echo "✅ Deployment complete!"
