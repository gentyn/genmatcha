#!/bin/bash

# Test Image Optimization Script
# Tests optimization on a few large images first

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Test Image Optimization${NC}"
echo "=============================="

# Test images (some of your largest)
TEST_IMAGES=(
    "public/images/matcha/PXL_20250530_203218645.png"
    "public/images/matcha/woodworking_in_progress.jpg"
    "public/images/portfolio/projects/interactive_art_installation/functional_demo.jpg"
)

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
optimize_test_image() {
    local input_file="$1"
    
    if [ ! -f "$input_file" ]; then
        echo -e "${YELLOW}⚠️  File not found: $input_file${NC}"
        return
    fi
    
    local original_size=$(get_file_size "$input_file")
    local filename=$(basename "$input_file")
    local name="${filename%.*}"
    local dir=$(dirname "$input_file")
    local output_file="$dir/${name}_test_opt.webp"
    
    echo -e "\n${YELLOW}Testing:${NC} $filename"
    echo "  Original size: $original_size"
    
    # Convert to WebP with optimization
    cwebp -q 85 -m 6 -mt -af -f 20 -sharpness 0 -nostrong -quiet "$input_file" -o "$output_file"
    
    local optimized_size=$(get_file_size "$output_file")
    
    # Calculate savings
    local original_bytes=$(stat -c%s "$input_file")
    local optimized_bytes=$(stat -c%s "$output_file")
    local savings=$(( (original_bytes - optimized_bytes) * 100 / original_bytes ))
    
    echo -e "  ${GREEN}✓${NC} Optimized size: $optimized_size"
    echo -e "  ${GREEN}✓${NC} Savings: ${savings}%"
    echo -e "  ${GREEN}✓${NC} Output: $(basename "$output_file")"
}

# Process test images
for image in "${TEST_IMAGES[@]}"; do
    optimize_test_image "$image"
done

echo -e "\n${GREEN}✅ Test Complete!${NC}"
echo "Check the _test_opt.webp files to see the results."
echo "If you're happy with the quality, run the full optimization script."
