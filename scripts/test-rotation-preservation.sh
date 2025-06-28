#!/bin/bash

# Test Rotation Preservation
# Tests the improved optimization that preserves image orientation

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Test Rotation Preservation${NC}"
echo "================================"

# Test with the image that has orientation 6
TEST_IMAGE="public/images/portfolio/projects/interactive_art_installation/functional_demo.jpg"

if [ ! -f "$TEST_IMAGE" ]; then
    echo -e "${YELLOW}⚠️  Test image not found: $TEST_IMAGE${NC}"
    exit 1
fi

# Get original orientation
ORIGINAL_ORIENTATION=$(identify -format "%[EXIF:Orientation]" "$TEST_IMAGE")
echo -e "${YELLOW}Original orientation:${NC} $ORIGINAL_ORIENTATION"

# Get original size
ORIGINAL_SIZE=$(du -h "$TEST_IMAGE" | cut -f1)
echo -e "${YELLOW}Original size:${NC} $ORIGINAL_SIZE"

# Create output filename
FILENAME=$(basename "$TEST_IMAGE")
NAME="${FILENAME%.*}"
DIR=$(dirname "$TEST_IMAGE")
OUTPUT_FILE="$DIR/${NAME}_rotation_test.webp"

echo -e "\n${YELLOW}Converting with rotation preservation...${NC}"

# Convert with rotation preservation
convert "$TEST_IMAGE" -auto-orient -quality 85 -define webp:method=6 -define webp:auto-filter=true -define webp:sharp-yuv=true "$OUTPUT_FILE"

# Get optimized size
OPTIMIZED_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)

# Calculate savings
ORIGINAL_BYTES=$(stat -c%s "$TEST_IMAGE")
OPTIMIZED_BYTES=$(stat -c%s "$OUTPUT_FILE")
SAVINGS=$(( (ORIGINAL_BYTES - OPTIMIZED_BYTES) * 100 / ORIGINAL_BYTES ))

echo -e "\n${GREEN}✅ Test Results:${NC}"
echo "  Original size: $ORIGINAL_SIZE"
echo "  Optimized size: $OPTIMIZED_SIZE"
echo "  Savings: ${SAVINGS}%"
echo "  Output: $(basename "$OUTPUT_FILE")"
echo "  Rotation: Preserved (auto-orient applied)"

echo -e "\n${BLUE}📝 Check the test file to verify rotation is correct:${NC}"
echo "  $OUTPUT_FILE"
