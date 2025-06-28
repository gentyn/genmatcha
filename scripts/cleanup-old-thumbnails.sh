#!/bin/bash

# Cleanup Old Thumbnails Script
# Removes old JPG/PNG thumbnail files since we now have WebP thumbnails

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Cleanup Old Thumbnails Script${NC}"
echo "====================================="

# Function to count files
count_files() {
    local pattern="$1"
    find public/images -name "$pattern" | grep thumbnails | wc -l
}

# Show current state
echo -e "\n${YELLOW}📊 Current State:${NC}"
old_jpg_count=$(count_files "*.jpg")
old_jpeg_count=$(count_files "*.jpeg")
old_png_count=$(count_files "*.png")
webp_count=$(count_files "*.webp")

echo "  Old JPG thumbnails: $old_jpg_count"
echo "  Old JPEG thumbnails: $old_jpeg_count"
echo "  Old PNG thumbnails: $old_png_count"
echo "  WebP thumbnails: $webp_count"
echo "  Total old files to remove: $((old_jpg_count + old_jpeg_count + old_png_count))"

# Calculate space to be freed
echo -e "\n${YELLOW}💾 Space Analysis:${NC}"
total_old_size=$(find public/images -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" | grep thumbnails | xargs du -ch 2>/dev/null | tail -1 | cut -f1)
echo "  Space to be freed: $total_old_size"

# Confirm before proceeding
echo -e "\n${YELLOW}⚠️  This script will:${NC}"
echo "1. Remove all old JPG/JPEG/PNG thumbnail files"
echo "2. Keep all WebP thumbnails (current format)"
echo "3. Keep all main image files"
echo ""

read -p "Do you want to proceed with cleanup? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Operation cancelled.${NC}"
    exit 1
fi

# Create backup of thumbnails directory
backup_dir="public/images_thumbnails_backup_$(date +%Y%m%d_%H%M%S)"
echo -e "\n${BLUE}📦 Creating backup...${NC}"
mkdir -p "$backup_dir"
cp -r public/images/*/thumbnails "$backup_dir/" 2>/dev/null || echo "No thumbnails directories found"
echo -e "${GREEN}✓${NC} Backup created at: $backup_dir"

# Remove old thumbnail files (batch)
echo -e "\n${BLUE}🗑️  Removing old thumbnail files...${NC}"
removed_count=0

# Remove JPG thumbnails
jpg_files=$(find public/images -name "*.jpg" | grep thumbnails)
jpeg_files=$(find public/images -name "*.jpeg" | grep thumbnails)
png_files=$(find public/images -name "*.png" | grep thumbnails)

removed_count=$(( $(echo "$jpg_files" | wc -l) + $(echo "$jpeg_files" | wc -l) + $(echo "$png_files" | wc -l) ))

# Remove all at once
if [ "$jpg_files" ]; then
  echo "$jpg_files" | xargs rm -f
fi
if [ "$jpeg_files" ]; then
  echo "$jpeg_files" | xargs rm -f
fi
if [ "$png_files" ]; then
  echo "$png_files" | xargs rm -f
fi

echo -e "\n${GREEN}🎉 Cleanup Complete!${NC}"
echo "================================"
echo "Files removed: $removed_count"
echo "Space freed: $total_old_size"
echo "Backup location: $backup_dir"

# Show new state
echo -e "\n${YELLOW}📊 New State:${NC}"
new_webp_count=$(count_files "*.webp")
echo "  WebP thumbnails remaining: $new_webp_count"
echo "  Old format thumbnails: 0"

# Check for any remaining old files
remaining_old=$(count_files "*.jpg")
remaining_old=$((remaining_old + $(count_files "*.jpeg")))
remaining_old=$((remaining_old + $(count_files "*.png")))

if [ $remaining_old -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All old thumbnails successfully removed!"
else
    echo -e "${YELLOW}⚠️  $remaining_old old thumbnail files still remain${NC}"
fi

echo -e "\n${BLUE}💡 Next Steps:${NC}"
echo "1. Test the site to ensure all images load correctly"
echo "2. Verify that WebP thumbnails are working properly"
echo "3. Commit the changes when satisfied"
echo "4. Consider removing the backup directory after testing"

echo -e "\n${YELLOW}⚠️  Note:${NC} Original files have been backed up to $backup_dir" 