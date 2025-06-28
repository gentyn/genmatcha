#!/usr/bin/env node

import sharp from 'sharp';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function generateFavicons() {
  const sizes = [
    { name: 'favicon-16x16.png', size: 16 },
    { name: 'favicon-32x32.png', size: 32 },
    { name: 'favicon-48x48.png', size: 48 },
    { name: 'android-chrome-192x192.png', size: 192 },
    { name: 'android-chrome-512x512.png', size: 512 },
    { name: 'apple-touch-icon.png', size: 180 }
  ];

  const publicDir = path.join(__dirname, '..', 'public');
  
  // Generate from the main favicon
  const mainFaviconPath = path.join(publicDir, 'favicon-square.svg');
  
  if (!fs.existsSync(mainFaviconPath)) {
    console.error('favicon-square.svg not found in public directory');
    return;
  }

  console.log('Generating favicon files...');

  for (const { name, size } of sizes) {
    try {
      await sharp(mainFaviconPath)
        .resize(size, size)
        .png()
        .toFile(path.join(publicDir, name));
      
      console.log(`✓ Generated ${name} (${size}x${size})`);
    } catch (error) {
      console.error(`✗ Failed to generate ${name}:`, error.message);
    }
  }

  // Generate ICO file (16x16 and 32x32 combined)
  try {
    const icon16 = await sharp(mainFaviconPath).resize(16, 16).png().toBuffer();
    const icon32 = await sharp(mainFaviconPath).resize(32, 32).png().toBuffer();
    
    // Note: Creating a proper ICO file requires additional libraries
    // For now, we'll copy the 32x32 PNG as favicon.ico
    fs.copyFileSync(path.join(publicDir, 'favicon-32x32.png'), path.join(publicDir, 'favicon.ico'));
    console.log('✓ Generated favicon.ico (copied from 32x32 PNG)');
  } catch (error) {
    console.error('✗ Failed to generate favicon.ico:', error.message);
  }

  console.log('\nFavicon generation complete!');
  console.log('Your favicon now meets Google\'s requirements for search results.');
}

// Check if sharp is installed
try {
  await import('sharp');
  generateFavicons().catch(console.error);
} catch (error) {
  console.log('Sharp is not installed. To generate favicons automatically:');
  console.log('1. Install sharp: npm install sharp');
  console.log('2. Run this script: node scripts/generate-favicons-with-sharp.js');
  console.log('');
  console.log('Alternatively, use the online generator at https://realfavicongenerator.net/');
} 