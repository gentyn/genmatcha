#!/bin/bash

# Image Restructuring Script
# Moves original images to backup, creates clean structure with optimized WebP images

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="$HOME/Desktop/genmatcha-images-backup"
QUALITY=85
EFFORT=6

echo -e "${BLUE}🔄 Image Restructuring Script${NC}"
echo "=================================="

# Function to get file size in human readable format
get_file_size() {
    local file="$1"
    if [ -f "$file" ]; then
        du -h "$file" | cut -f1
    else
        echo "0B"
    fi
}

# Function to create clean WebP filename
create_clean_filename() {
    local input_file="$1"
    local filename=$(basename "$input_file")
    local name="${filename%.*}"
    local ext="${filename##*.}"
    
    # Remove common prefixes and create clean name
    name=$(echo "$name" | sed 's/^PXL_[0-9]*_//' | sed 's/^IMG_//' | sed 's/^1377402494165979228remix-//')
    
    # Convert to lowercase and replace spaces/special chars
    name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_//' | sed 's/_$//')
    
    echo "${name}.webp"
}

# Function to optimize and save with clean filename
optimize_image_clean() {
    local input_file="$1"
    local output_dir="$2"
    local clean_filename="$3"
    local output_file="$output_dir/$clean_filename"
    
    local original_size=$(get_file_size "$input_file")
    local orientation=$(identify -format "%[EXIF:Orientation]" "$input_file" 2>/dev/null || echo "")
    
    echo -e "${YELLOW}Processing:${NC} $(basename "$input_file")"
    echo "  Original size: $original_size"
    echo "  Clean filename: $clean_filename"
    
    if [ -n "$orientation" ] && [ "$orientation" != "" ]; then
        echo "  Orientation: $orientation (will be preserved)"
    fi
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Convert with rotation preservation
    convert "$input_file" -auto-orient -quality $QUALITY -define webp:method=$EFFORT -define webp:auto-filter=true -define webp:sharp-yuv=true "$output_file"
    
    local optimized_size=$(get_file_size "$output_file")
    
    # Calculate savings
    local original_bytes=$(stat -c%s "$input_file")
    local optimized_bytes=$(stat -c%s "$output_file")
    local savings=$(( (original_bytes - optimized_bytes) * 100 / original_bytes ))
    
    echo -e "  ${GREEN}✓${NC} Optimized size: $optimized_size"
    echo -e "  ${GREEN}✓${NC} Savings: ${savings}%"
    echo -e "  ${GREEN}✓${NC} Saved as: $clean_filename"
}

# Function to process directory
process_directory() {
    local source_dir="$1"
    local target_dir="$2"
    local context="$3"
    
    if [ ! -d "$source_dir" ]; then
        echo -e "${RED}⚠️  Source directory not found: $source_dir${NC}"
        return
    fi
    
    echo -e "\n${BLUE}📁 Processing: $source_dir${NC}"
    
    # Find all image files
    local image_files=($(find "$source_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | grep -v "_opt" | grep -v "_test"))
    
    if [ ${#image_files[@]} -eq 0 ]; then
        echo "  No images found to optimize"
        return
    fi
    
    local total_original=0
    local total_optimized=0
    local processed=0
    
    for file in "${image_files[@]}"; do
        # Skip test files
        if [[ "$file" == *_test* ]]; then
            continue
        fi
        
        # Create clean filename
        local clean_filename=$(create_clean_filename "$file")
        
        # Get original size in bytes
        local original_bytes=$(stat -c%s "$file")
        total_original=$((total_original + original_bytes))
        
        # Optimize the image
        optimize_image_clean "$file" "$target_dir" "$clean_filename"
        
        # Get optimized size in bytes
        local output_file="$target_dir/$clean_filename"
        local optimized_bytes=$(stat -c%s "$output_file")
        total_optimized=$((total_optimized + optimized_bytes))
        processed=$((processed + 1))
    done
    
    # Calculate total savings
    local total_savings=0
    if [ $total_original -gt 0 ]; then
        total_savings=$(( (total_original - total_optimized) * 100 / total_original ))
    fi
    
    echo -e "\n${GREEN}📊 Summary for $source_dir:${NC}"
    echo "  Processed: $processed images"
    echo "  Original: $(numfmt --to=iec $total_original)"
    echo "  Optimized: $(numfmt --to=iec $total_optimized)"
    echo "  Total savings: ${total_savings}%"
}

# Main execution
main() {
    echo -e "${YELLOW}⚠️  This script will:${NC}"
    echo "1. Create backup of original images at: $BACKUP_DIR"
    echo "2. Generate optimized WebP images with clean filenames"
    echo "3. Replace original images in the repo"
    echo ""
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 1
    fi
    
    # Create backup directory
    echo -e "\n${BLUE}📦 Creating backup...${NC}"
    mkdir -p "$BACKUP_DIR"
    
    # Backup original images
    if [ -d "public/images" ]; then
        cp -r "public/images" "$BACKUP_DIR/"
        echo -e "${GREEN}✓${NC} Backup created at: $BACKUP_DIR/images"
    fi
    
    # Create temporary directory for new structure
    local temp_dir="public/images-optimized"
    mkdir -p "$temp_dir"
    
    # Process directories
    local dirs=(
        "public/images/matcha:public/images/matcha:gallery"
        "public/images/portfolio/projects:public/images/portfolio/projects:full"
        "public/images/personal_projects:public/images/personal_projects:full"
    )
    
    local total_original=0
    local total_optimized=0
    
    for dir_config in "${dirs[@]}"; do
        IFS=':' read -r source_dir target_dir context <<< "$dir_config"
        
        if [ -d "$source_dir" ]; then
            # Get stats before processing
            local dir_original=$(find "$source_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
            local dir_optimized=0
            
            process_directory "$source_dir" "$target_dir" "$context"
            
            # Get stats after processing
            dir_optimized=$(find "$target_dir" -maxdepth 1 -type f -name "*.webp" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
            
            total_original=$((total_original + dir_original))
            total_optimized=$((total_optimized + dir_optimized))
        fi
    done
    
    # Final summary
    local total_savings=0
    if [ $total_original -gt 0 ]; then
        total_savings=$(( (total_original - total_optimized) * 100 / total_original ))
    fi
    
    echo -e "\n${GREEN}🎉 Restructuring Complete!${NC}"
    echo "================================"
    echo "Total original size: $(numfmt --to=iec $total_original)"
    echo "Total optimized size: $(numfmt --to=iec $total_optimized)"
    echo "Total savings: ${total_savings}%"
    echo -e "${GREEN}✓${NC} All rotations preserved"
    echo -e "${GREEN}✓${NC} Clean filenames created"
    echo -e "${GREEN}✓${NC} Backup saved to: $BACKUP_DIR"
    
    echo -e "\n${YELLOW}📝 Next Steps:${NC}"
    echo "1. Review the optimized images with clean filenames"
    echo "2. Update your ProgressiveImage components to use new filenames"
    echo "3. Test the site to ensure everything works"
    echo "4. Commit the changes when satisfied"
    echo "5. Original images are safely backed up at: $BACKUP_DIR"
}

# Run the script
main "$@"
