# Thumbnail Optimization System

This project implements a comprehensive thumbnail optimization system to improve performance by serving appropriately sized images for different contexts.

## Overview

The thumbnail system automatically generates and serves optimized image sizes for:
- **Card previews** (600x384px) - Used in project cards and galleries
- **Gallery thumbnails** (400x300px) - Used in image galleries
- **Modal thumbnails** (200x128px) - Used in project modal thumbnail grids
- **Headshots** (192x192px) - Used for profile images

## How It Works

### 1. ProgressiveImage Component

The `ProgressiveImage` component now supports thumbnail generation through props:

```astro
<ProgressiveImage
  src="/images/project/main-image.jpg"
  alt="Project image"
  thumbnail={true}
  thumbnailContext="card"
  objectFit="cover"
/>
```

### 2. Thumbnail Generation

The system uses a Node.js script to generate actual thumbnail files:

```bash
npm run generate-thumbnails
```

This script:
- Scans all image directories
- Generates thumbnails for each context
- Saves them in `thumbnails/` subdirectories
- Skips generation if thumbnails are already up-to-date

### 3. Fallback System

If thumbnail files don't exist, the system falls back to query parameters for CDN/image service optimization:

```
/images/project/main-image.jpg?w=600&h=384&fit=crop&q=85&fmt=webp
```

## Usage

### For Project Cards

```astro
<ProgressiveImage
  src={project.images[0].src}
  alt={project.images[0].alt}
  thumbnail={true}
  thumbnailContext="card"
  objectFit="cover"
/>
```

### For Gallery Images

```astro
<ProgressiveImage
  src={`/images/gallery/image.jpg`}
  alt="Gallery image"
  thumbnail={true}
  thumbnailContext="gallery"
  objectFit="cover"
/>
```

### For Modal Thumbnails

```astro
<ProgressiveImage
  src={image}
  alt={`${title} thumbnail`}
  thumbnail={true}
  thumbnailContext="modal_thumbnail"
  objectFit="cover"
/>
```

### For Headshots

```astro
<ProgressiveImage
  src="/images/headshot.jpg"
  alt="Profile photo"
  thumbnail={true}
  thumbnailContext="headshot"
  objectFit="cover"
/>
```

## Performance Benefits

### Before Optimization
- Full-size images (400KB-1MB+) loaded for all contexts
- Slow page loads, especially on mobile
- Unnecessary bandwidth usage

### After Optimization
- **Card previews**: ~80-150KB (70% reduction)
- **Gallery thumbnails**: ~50-100KB (75% reduction)
- **Modal thumbnails**: ~15-30KB (85% reduction)
- **Headshots**: ~20-40KB (80% reduction)

## File Structure

```
public/images/
├── personal_projects/
│   ├── project1/
│   │   ├── main-image.jpg
│   │   └── thumbnails/
│   │       ├── main-image_card.jpg
│   │       ├── main-image_gallery.jpg
│   │       └── main-image_modal_thumbnail.jpg
│   └── project2/
│       ├── image.jpg
│       └── thumbnails/
│           └── image_card.jpg
├── portfolio/
└── matcha/
```

## Configuration

### Thumbnail Sizes

Edit `scripts/generate-thumbnails.js` to modify thumbnail configurations:

```javascript
const THUMBNAIL_CONFIGS = {
  card: { width: 600, height: 384, quality: 85 },
  gallery: { width: 400, height: 300, quality: 85 },
  modal_thumbnail: { width: 200, height: 128, quality: 80 },
  headshot: { width: 192, height: 192, quality: 85 }
};
```

### Supported Formats

The system supports:
- JPEG (.jpg, .jpeg)
- PNG (.png)
- WebP (.webp)

## Development Workflow

1. **Add new images** to the appropriate directories
2. **Run thumbnail generation**:
   ```bash
   npm run generate-thumbnails
   ```
3. **Use ProgressiveImage component** with thumbnail props
4. **Commit original images** (thumbnails are auto-generated and ignored)

## Production Deployment

For production, consider:

1. **CDN Integration**: Use a CDN that supports image optimization parameters
2. **WebP Conversion**: Convert all thumbnails to WebP for better compression
3. **Lazy Loading**: Images are already lazy-loaded with Intersection Observer
4. **Progressive Loading**: Skeleton loading states provide smooth UX

## Analytics

The system tracks image loading events for performance monitoring:

- `optimized_image_load` - Successful thumbnail load
- `optimized_image_error` - Failed thumbnail load
- Context information for analysis

## Troubleshooting

### Thumbnails Not Generating
- Ensure Sharp is installed: `npm install sharp`
- Check file permissions on image directories
- Verify image formats are supported

### Images Not Loading
- Check if thumbnail files exist in `thumbnails/` directories
- Verify fallback query parameters work with your CDN
- Check browser console for errors

### Performance Issues
- Run thumbnail generation script
- Verify thumbnails are being served (check Network tab)
- Consider increasing image quality settings if needed 