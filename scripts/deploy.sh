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
    newmoonadmin@newmooncloud.com:/var/www/newmooncloud/

# Restart Apache
echo "🔄 Restarting Apache..."
ssh -p 12202 -i /home/genesis/.ssh/genmatcha_deploy newmoonadmin@newmooncloud.com "sudo systemctl restart apache2"

echo "✅ Deployment complete!"
