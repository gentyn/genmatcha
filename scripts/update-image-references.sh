#!/bin/bash

# Update Image References Script
# Updates all image references in the codebase to use new WebP filenames

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Updating Image References${NC}"
echo "================================"

# Create a mapping file for reference
cat > image-mapping.txt << 'MAPPING'
# Image Filename Mapping
# Original -> New WebP

# Matcha Images
PXL_20250530_203218645.png -> 203218645.webp
PXL_20250530_194640510.jpg -> 194640510.webp
IMG_2885.jpg -> 2885.webp
PXL_20250531_220509851.jpg -> 220509851.webp
PXL_20250505_200558431.jpg -> 200558431.webp
PXL_20250419_183852785.jpg -> 183852785.webp
PXL_20250505_200625410.jpg -> 200625410.webp
PXL_20250410_180754746.jpg -> 180754746.webp
PXL_20250506_200225579.jpg -> 200225579.webp
1377402494165979228remix-1748468776629.png -> 1748468776629.webp
IMG_2051.png.jpg -> 2051_png.webp
IMG_1949.png.jpg -> 1949_png.webp
PXL_20250322_193233236.jpg -> 193233236.webp
d5bb5487-6df7-4ef3-97b7-8d27782d9f20.jpg -> d5bb5487_6df7_4ef3_97b7_8d27782d9f20.webp
PXL_20250529_205414879.jpg -> 205414879.webp
PXL_20250411_193327647.jpg -> 193327647.webp
IMG_2485.webp.jpg -> 2485_webp.webp

# Personal Projects
matcha_site_thumbnail.png -> matcha_site_thumbnail.webp
MAPPING

echo -e "${GREEN}✓${NC} Created image mapping file: image-mapping.txt"

# Function to update file references
update_file_references() {
    local file="$1"
    local updated=false
    
    echo -e "${YELLOW}Checking:${NC} $file"
    
    # Update matcha images
    if sed -i 's|PXL_20250530_203218645\.png|203218645.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250530_194640510\.jpg|194640510.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|IMG_2885\.jpg|2885.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250531_220509851\.jpg|220509851.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250505_200558431\.jpg|200558431.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250419_183852785\.jpg|183852785.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250505_200625410\.jpg|200625410.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250410_180754746\.jpg|180754746.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250506_200225579\.jpg|200225579.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|1377402494165979228remix-1748468776629\.png|1748468776629.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|IMG_2051\.png\.jpg|2051_png.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|IMG_1949\.png\.jpg|1949_png.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250322_193233236\.jpg|193233236.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|d5bb5487-6df7-4ef3-97b7-8d27782d9f20\.jpg|d5bb5487_6df7_4ef3_97b7_8d27782d9f20.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250529_205414879\.jpg|205414879.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|PXL_20250411_193327647\.jpg|193327647.webp|g' "$file" 2>/dev/null; then updated=true; fi
    if sed -i 's|IMG_2485\.webp\.jpg|2485_webp.webp|g' "$file" 2>/dev/null; then updated=true; fi
    
    # Update personal projects
    if sed -i 's|matcha_site_thumbnail\.png|matcha_site_thumbnail.webp|g' "$file" 2>/dev/null; then updated=true; fi
    
    if [ "$updated" = true ]; then
        echo -e "  ${GREEN}✓${NC} Updated references"
    else
        echo -e "  No references found"
    fi
}

# Find and update all relevant files
echo -e "\n${BLUE}📝 Updating file references...${NC}"

# Update Astro files
for file in $(find src -name "*.astro" -type f); do
    update_file_references "$file"
done

# Update JSON files
for file in $(find src -name "*.json" -type f); do
    update_file_references "$file"
done

# Update TypeScript files
for file in $(find src -name "*.ts" -type f); do
    update_file_references "$file"
done

echo -e "\n${GREEN}🎉 Reference Update Complete!${NC}"
echo "================================"
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "1. Review the changes in your code files"
echo "2. Test the site to ensure images load correctly"
echo "3. Check that all image references are updated"
echo "4. Commit the changes when satisfied"
echo "5. Reference image-mapping.txt for filename mappings"
