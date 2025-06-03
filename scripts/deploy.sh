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
rsync -avz --delete -e "ssh -o IdentitiesOnly=yes -F /dev/null -p 12202 -i /home/genesis/.ssh/genmatcha_deployer" \
    dist/ \
    deployer@newmooncloud.com:/var/www/genmatcha/

echo "✅ Deployment complete!"
