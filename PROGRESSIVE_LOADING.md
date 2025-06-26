# Progressive Image Loading Implementation

This document outlines the progressive image loading implementation across the GenMatcha website.

## Overview

The progressive loading system provides a smooth, performant image loading experience with:
- Skeleton loading animations
- Intersection Observer for lazy loading
- Smooth opacity transitions
- Error handling
- Accessibility support

## Components

### ProgressiveImage.astro

The main component that handles all progressive loading scenarios.

**Props:**
- `src` (required): Image source URL
- `alt` (required): Alt text for accessibility
- `className` (optional): Additional CSS classes
- `style` (optional): Inline styles
- `width` (optional): Image width
- `height` (optional): Image height
- `priority` (optional): Set to `true` for above-the-fold images
- `placeholder` (optional): Low-quality placeholder URL
- `objectFit` (optional): CSS object-fit value ('cover', 'contain', 'fill', 'none', 'scale-down'). Defaults to 'cover'

**Features:**
- Automatic skeleton loading with themed colors
- Intersection Observer for performance
- Smooth fade-in transitions
- Error state handling
- Hover effects
- Dark mode support

## Implementation Details

### Loading States

1. **Skeleton State**: Shows animated shimmer effect with themed colors
2. **Loading State**: Image loads in background
3. **Loaded State**: Smooth opacity transition to full image
4. **Error State**: Graceful fallback with reduced opacity

### Themed Skeleton Loading

The skeleton loading state uses colors that match the site's theme:
- **Light Mode**: `#F0F0E8` to `#E8E8E0` (matches site background)
- **Dark Mode**: `#262926` to `#2A2D2A` (matches site background)

This prevents jarring color flashes during image loading and provides a seamless experience.

### Performance Optimizations

- **Intersection Observer**: Only loads images when they're about to enter viewport
- **Lazy Loading**: Uses native `loading="lazy"` attribute
- **Priority Loading**: Above-the-fold images load immediately
- **Memory Management**: Unobserves images after loading

### Browser Support

- **Modern Browsers**: Full progressive loading with Intersection Observer
- **Older Browsers**: Fallback to immediate loading
- **No JavaScript**: Graceful degradation with native lazy loading

## Usage Examples

### Basic Usage (Project Cards - Fill Space)
```astro
<ProgressiveImage
  src="/images/project.jpg"
  alt="Project screenshot"
  className="w-full h-64"
/>
```

### With Priority Loading
```astro
<ProgressiveImage
  src="/images/hero.jpg"
  alt="Hero image"
  className="w-full h-96"
  priority={true}
/>
```

### With Placeholder
```astro
<ProgressiveImage
  src="/images/project.jpg"
  alt="Project screenshot"
  placeholder="/images/project-placeholder.jpg"
  className="w-full h-64"
/>
```

### Content Images (Show Full Image)
```astro
<ProgressiveImage
  src="/images/content.jpg"
  alt="Content image"
  className="w-full"
  style="max-height: 60vh;"
  objectFit="contain"
/>
```

### Modal Gallery Images (Show Full Image with Background)
```astro
<ProgressiveImage
  src="/images/gallery.jpg"
  alt="Gallery image"
  className="w-full"
  style="height: 70vh;"
  priority={true}
  objectFit="contain"
/>
```

## Object-Fit Behaviors

The `objectFit` prop controls how images are sized within their containers:

### `cover` (Default)
- **Behavior**: Image fills the entire container, maintaining aspect ratio
- **Excess**: Cropped from center
- **Use Cases**: Project cards, gallery thumbnails, hero images
- **Example**: `objectFit="cover"` or omit (default)

### `contain`
- **Behavior**: Image fits entirely within container, maintaining aspect ratio
- **Excess**: Shows background space around image
- **Use Cases**: Modal gallery main images, content images, logos
- **Example**: `objectFit="contain"`

### Other Options
- `fill`: Stretches image to fill container (may distort)
- `none`: No resizing, may overflow container
- `scale-down`: Like `contain` but never scales up

## Integration Points

### Pages Using ProgressiveImage

1. **Homepage** (`src/pages/index.astro`)
   - Project card images
   - Featured project thumbnails

2. **Personal Projects** (`src/pages/personal_projects.astro`)
   - Project card images
   - Gallery thumbnails

3. **Matcha Page** (`src/pages/matcha/index.astro`)
   - Image gallery
   - Animated floating images

4. **Project Modals** (`src/components/ProjectModal.astro`)
   - Main project images
   - Thumbnail gallery

5. **Content Blocks** (`src/components/ContentBlock.astro`)
   - Content images
   - Blog post images

## Utilities

### imageUtils.ts

Helper functions for image processing:

- `generatePlaceholderUrl()`: Create low-quality placeholders
- `supportsPlaceholderGeneration()`: Check if URL supports placeholders
- `preloadImage()`: Preload images programmatically
- `getImageDimensions()`: Get image dimensions

## Styling

### CSS Classes

- `.progressive-image-container`: Main container
- `.progressive-skeleton`: Skeleton loading animation
- `.progressive-main-image`: Main image element
- `.progressive-main-image.loaded`: Loaded state

### Animations

- **Shimmer Effect**: CSS gradient animation for skeleton loading
- **Fade In**: Opacity transition for loaded images
- **Hover Effects**: Scale transform on hover

## Performance Metrics

### Before Implementation
- All images loaded on page load
- No loading states
- Potential layout shifts

### After Implementation
- Images load only when needed
- Smooth loading states
- Reduced initial page load time
- Better Core Web Vitals scores

## Future Enhancements

### Planned Features

1. **WebP/AVIF Support**: Automatic format selection
2. **Responsive Images**: Multiple sizes for different screens
3. **Blur-up Effect**: Low-quality to high-quality transitions
4. **Preloading**: Critical images preloaded
5. **Caching**: Service worker integration

### Image Optimization

- Consider implementing image optimization pipeline
- Add WebP/AVIF conversion
- Implement responsive image sizes
- Add image compression

## Maintenance

### Regular Tasks

1. **Monitor Performance**: Check Core Web Vitals
2. **Update Dependencies**: Keep Intersection Observer polyfills current
3. **Test Browser Support**: Ensure fallbacks work
4. **Optimize Images**: Compress and convert formats

### Troubleshooting

**Images not loading:**
- Check network connectivity
- Verify image URLs
- Check browser console for errors

**Skeleton not hiding:**
- Verify JavaScript is enabled
- Check for CSS conflicts
- Ensure proper z-index values

**Performance issues:**
- Monitor Intersection Observer usage
- Check for memory leaks
- Optimize image sizes

## Accessibility

### Features Implemented

- Proper alt text support
- Keyboard navigation
- Screen reader compatibility
- Focus management
- ARIA labels

### Best Practices

- Always provide meaningful alt text
- Use semantic HTML structure
- Ensure sufficient color contrast
- Test with screen readers
- Support keyboard-only navigation 