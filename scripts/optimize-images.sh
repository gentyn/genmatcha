#!/bin/bash

# Image Optimization Script
# Converts images to WebP, optimizes quality, and removes EXIF data

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
QUALITY=85
EFFORT=6

echo -e "${BLUE}🖼️  Image Optimization Script${NC}"
echo "================================"

# Function to get file size in human readable format
get_file_size() {
    local file="$1"
    if [ -f "$file" ]; then
        du -h "$file" | cut -f1
    else
        echo "0B"
    fi
}

# Function to optimize a single image
optimize_image() {
    local input_file="$1"
    local output_file="$2"
    local original_size=$(get_file_size "$input_file")
    
    echo -e "${YELLOW}Processing:${NC} $(basename "$input_file")"
    
    # Convert to WebP with optimization
    cwebp -q $QUALITY -m $EFFORT -mt -af -f 20 -sharpness 0 -nostrong -quiet "$input_file" -o "$output_file"
    
    local optimized_size=$(get_file_size "$output_file")
    
    # Calculate savings
    local original_bytes=$(stat -c%s "$input_file" 2>/dev/null || stat -f%z "$input_file")
    local optimized_bytes=$(stat -c%s "$output_file" 2>/dev/null || stat -f%z "$output_file")
    local savings=$(( (original_bytes - optimized_bytes) * 100 / original_bytes ))
    
    echo -e "  ${GREEN}✓${NC} Original: $original_size → Optimized: $optimized_size (${savings}% smaller)"
}

# Function to process directory
process_directory() {
    local dir="$1"
    local context="$2"
    
    if [ ! -d "$dir" ]; then
        echo -e "${RED}⚠️  Directory not found: $dir${NC}"
        return
    fi
    
    echo -e "\n${BLUE}📁 Processing: $dir${NC}"
    
    # Find all image files
    local image_files=($(find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | grep -v "_opt"))
    
    if [ ${#image_files[@]} -eq 0 ]; then
        echo "  No images found to optimize"
        return
    fi
    
    local total_original=0
    local total_optimized=0
    local processed=0
    
    for file in "${image_files[@]}"; do
        # Skip if already optimized
        if [[ "$file" == *_opt* ]]; then
            continue
        fi
        
        # Create output filename
        local filename=$(basename "$file")
        local name="${filename%.*}"
        local ext="${filename##*.}"
        local output_file="$dir/${name}_opt.webp"
        
        # Get original size in bytes
        local original_bytes=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")
        total_original=$((total_original + original_bytes))
        
        # Optimize the image
        optimize_image "$file" "$output_file"
        
        # Get optimized size in bytes
        local optimized_bytes=$(stat -c%s "$output_file" 2>/dev/null || stat -f%z "$output_file")
        total_optimized=$((total_optimized + optimized_bytes))
        processed=$((processed + 1))
    done
    
    # Calculate total savings
    local total_savings=0
    if [ $total_original -gt 0 ]; then
        total_savings=$(( (total_original - total_optimized) * 100 / total_original ))
    fi
    
    echo -e "\n${GREEN}📊 Summary for $dir:${NC}"
    echo "  Processed: $processed images"
    echo "  Original: $(numfmt --to=iec $total_original)"
    echo "  Optimized: $(numfmt --to=iec $total_optimized)"
    echo "  Total savings: ${total_savings}%"
}

# Main execution
main() {
    # Directories to process
    local dirs=(
        "public/images/matcha"
        "public/images/portfolio/projects"
        "public/images/personal_projects"
    )
    
    local total_original=0
    local total_optimized=0
    local total_processed=0
    
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            # Get stats before processing
            local dir_original=$(find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
            local dir_optimized=0
            
            process_directory "$dir" "gallery"
            
            # Get stats after processing
            dir_optimized=$(find "$dir" -maxdepth 1 -type f -name "*_opt.webp" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
            
            total_original=$((total_original + dir_original))
            total_optimized=$((total_optimized + dir_optimized))
        fi
    done
    
    # Final summary
    local total_savings=0
    if [ $total_original -gt 0 ]; then
        total_savings=$(( (total_original - total_optimized) * 100 / total_original ))
    fi
    
    echo -e "\n${GREEN}🎉 Optimization Complete!${NC}"
    echo "================================"
    echo "Total original size: $(numfmt --to=iec $total_original)"
    echo "Total optimized size: $(numfmt --to=iec $total_optimized)"
    echo "Total savings: ${total_savings}%"
    
    echo -e "\n${YELLOW}📝 Next Steps:${NC}"
    echo "1. Review the optimized images (_opt.webp files)"
    echo "2. Update your ProgressiveImage components to use optimized versions"
    echo "3. Test page load performance improvements"
    echo "4. Consider removing original files after testing"
}

# Run the script
main "$@"
