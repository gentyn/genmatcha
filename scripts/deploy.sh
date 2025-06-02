#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting deployment..."

# Build the site
echo "📦 Building site..."
cd genmatcha-astro
npm run build

# Sync to server
echo "📤 Syncing to server..."
rsync -avz --delete -e "ssh -p 12202 -i /home/genesis/.ssh/id_ed25519" \
    dist/ \
    newmoonadmin@newmooncloud.com:/var/www/newmooncloud/

echo "✅ Deployment complete!"
