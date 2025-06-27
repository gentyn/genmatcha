#!/usr/bin/env node

/**
 * Thumbnail Generation Script
 * 
 * This script generates optimized thumbnail images for better performance.
 * It uses Sharp to resize images and save them in a thumbnails directory.
 * 
 * Usage: node scripts/generate-thumbnails.js
 */

import fs from 'fs';
import path from 'path';
import sharp from 'sharp';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Thumbnail configurations
const THUMBNAIL_CONFIGS = {
  card: { width: 600, height: 384, quality: 85 },
  gallery: { width: 400, height: 300, quality: 85 },
  modal_thumbnail: { width: 200, height: 128, quality: 80 },
  headshot: { width: 192, height: 192, quality: 85 }
};

// Directories to process
const IMAGE_DIRECTORIES = [
  'public/images/personal_projects',
  'public/images/portfolio',
  'public/images/matcha'
];

// File extensions to process
const IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.webp'];

/**
 * Generate thumbnails for a single image
 */
async function generateThumbnails(imagePath) {
  try {
    const ext = path.extname(imagePath).toLowerCase();
    if (!IMAGE_EXTENSIONS.includes(ext)) {
      return;
    }

    const imageBuffer = fs.readFileSync(imagePath);
    const imageName = path.basename(imagePath, ext);
    const imageDir = path.dirname(imagePath);
    const thumbnailsDir = path.join(imageDir, 'thumbnails');

    // Create thumbnails directory if it doesn't exist
    if (!fs.existsSync(thumbnailsDir)) {
      fs.mkdirSync(thumbnailsDir, { recursive: true });
    }

    // Generate thumbnails for each configuration
    for (const [context, config] of Object.entries(THUMBNAIL_CONFIGS)) {
      const thumbnailPath = path.join(thumbnailsDir, `${imageName}_${context}${ext}`);
      
      // Skip if thumbnail already exists and is newer than source
      // if (fs.existsSync(thumbnailPath)) {
      //   const sourceStats = fs.statSync(imagePath);
      //   const thumbnailStats = fs.statSync(thumbnailPath);
      //   if (thumbnailStats.mtime > sourceStats.mtime) {
      //     console.log(`Skipping ${imageName}_${context} (already up to date)`);
      //     continue;
      //   }
      // }

      await sharp(imageBuffer)
        .resize(config.width, config.height, {
          fit: 'cover',
          position: 'center'
        })
        .jpeg({ quality: config.quality })
        .toFile(thumbnailPath);

      console.log(`Generated ${imageName}_${context} (${config.width}x${config.height})`);
    }
  } catch (error) {
    console.error(`Error processing ${imagePath}:`, error.message);
  }
}

/**
 * Recursively find all images in a directory
 */
function findImages(dir) {
  const images = [];
  
  if (!fs.existsSync(dir)) {
    return images;
  }

  const items = fs.readdirSync(dir);
  
  for (const item of items) {
    const itemPath = path.join(dir, item);
    const stats = fs.statSync(itemPath);
    
    if (stats.isDirectory()) {
      // Skip thumbnails directory to avoid infinite recursion
      if (item !== 'thumbnails') {
        images.push(...findImages(itemPath));
      }
    } else if (stats.isFile()) {
      const ext = path.extname(item).toLowerCase();
      if (IMAGE_EXTENSIONS.includes(ext)) {
        images.push(itemPath);
      }
    }
  }
  
  return images;
}

/**
 * Main function
 */
async function main() {
  console.log('🚀 Starting thumbnail generation...\n');

  let totalProcessed = 0;
  let totalErrors = 0;

  for (const imageDir of IMAGE_DIRECTORIES) {
    console.log(`📁 Processing directory: ${imageDir}`);
    
    const images = findImages(imageDir);
    console.log(`   Found ${images.length} images\n`);

    for (const imagePath of images) {
      try {
        await generateThumbnails(imagePath);
        totalProcessed++;
      } catch (error) {
        console.error(`❌ Error processing ${imagePath}:`, error.message);
        totalErrors++;
      }
    }
  }

  console.log('\n✅ Thumbnail generation complete!');
  console.log(`   Processed: ${totalProcessed} images`);
  if (totalErrors > 0) {
    console.log(`   Errors: ${totalErrors}`);
  }
  console.log('\n💡 Tip: Add thumbnails/ to your .gitignore to avoid committing generated thumbnails');
}

// Run the script
main().catch(console.error); 